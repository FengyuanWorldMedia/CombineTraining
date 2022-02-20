// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

/// 指定 ShareReplaySubscription 的 两个范型
final class ShareReplaySubscription<Output, Failure: Error>: Combine.Subscription, Equatable {
    
    /// 缓存的结果个数。
    let capacity: Int
    /// 缓存的结果
    var buffer: [Output]
    /// 订阅者
    var subscriber: AnySubscriber<Output, Failure>? = nil
    /// 发送次数
    var demand: Subscribers.Demand = .none
    /// 结束标识
    var completion : Subscribers.Completion<Failure>? = nil
    
    private var cancelSubscription: (ShareReplaySubscription<Output, Failure>) -> Void
    
    init<S>(subscriber: S , replay: [Output] , capacity: Int , completion : Subscribers.Completion<Failure>?,
            cancel: @escaping (ShareReplaySubscription<Output, Failure>) -> Void) where S: Subscriber , Failure == S.Failure , Output == S.Input {
        self.subscriber = AnySubscriber(subscriber)
        self.buffer = replay
        self.capacity = capacity
        self.completion = completion
        self.cancelSubscription = cancel
    }
    
    /// 注意这里的subscriber 应该不是 引用类型
    private func complete(with completion: Subscribers.Completion<Failure>) {
        guard let subscriber = self.subscriber else {  /// 注意： struct AnySubscriber 是结构体。
            return
        }
        self.subscriber = nil
        self.completion = nil
        /// 结束的时候，就把缓存的数据全部删除，且通知 订阅者已经结束。
        self.buffer.removeAll()
        subscriber.receive(completion: completion)
    }
    
    /// 本方法在 建立订阅的时候，在request 方法中调用。
    /// 把缓存的信息，全部发送给订阅者，同时更新 self.demand
    /// 如果已经结束的话，就把结束的结果也发给订阅者。
    private func emitAsNeeded() {
        guard let subscriber = self.subscriber else {
            return
        }
        while self.demand > .none && !self.buffer.isEmpty {
            self.demand -= .max(1)
            let nextDemand = subscriber.receive(buffer.removeFirst())
            if nextDemand != .none {
                self.demand += nextDemand
            }
        }
        if let completion = self.completion {
            complete(with: completion)
        }
    }
    
    /// 首次请求配置信息
    func request(_ demand: Subscribers.Demand) {
        if demand != .none {
            self.demand += demand
        }
        emitAsNeeded()
    }
    
    /// 把当前订阅 在 发布者的订阅List中删除。
    func cancel() {
        cancelSubscription(self)
    }
    
    /// 次方法在 Publisher中调用
    func receiveForPubliser(_ input : Output) {
        guard self.subscriber != nil else {
            return
        }
        buffer.append(input)
        if buffer.count > capacity {
            buffer.removeFirst()
        }
        emitAsNeeded()
    }
    
    /// 次方法在 Publisher中调用
    func receiveForPubliser(completion : Subscribers.Completion<Failure>) {
        guard let subscriber = self.subscriber else {
            return
        }
        self.subscriber = nil
        self.buffer.removeAll()
        subscriber.receive(completion: completion)
    }
    
    static func == (lhs: ShareReplaySubscription<Output, Failure>, rhs: ShareReplaySubscription<Output, Failure>) -> Bool {
        lhs.combineIdentifier == rhs.combineIdentifier
    }
}


extension Publishers {
    
    class SharedReplay<Upstream: Publisher> : Publisher {
        
        typealias Output = Upstream.Output
        typealias Failure = Upstream.Failure
     
        private let lock = NSRecursiveLock()
        private let upstream : Upstream
        private let capacity : Int
        private var replay = [Output]()
        private var subscriptions = [ShareReplaySubscription<Output,Failure>]()
        private var completion : Subscribers.Completion<Failure>? = nil
        
        init(upstream: Upstream , capacity: Int) {
            self.upstream = upstream
            self.capacity = capacity
        }
        
        /// 在第一个 sink 接受到数据后，就可以 replay进行。让所有的 订阅 进行发送数据。
        private func replay(_ value : Output) {
            lock.lock()
            defer {
                lock.unlock()
            }
            guard completion == nil else {
                return
            }
            self.replay.append(value)
            if self.replay.capacity > capacity {
                self.replay.removeFirst()
            }
            subscriptions.forEach {
                $0.receiveForPubliser(value)
            }
        }
        
        /// 清除缓存，不在进行发送，同时 让所有的 订阅 进行发送 结束数据。同时保留self.completion ，意味着 replay方法不再 发送数据。
        private func complete(with completion:  Subscribers.Completion<Failure>) {
            lock.lock()
            defer {
                lock.unlock()
            }
            self.replay.removeAll() 
            self.completion = completion
            subscriptions.forEach {
                $0.receiveForPubliser(completion: completion)
            }
        }
        
        /// 本方法是SharedReplay 发布者 和 订阅者subscriber 进行关联， 产生订阅关系。
        func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            lock.lock()
            defer {
                lock.unlock()
            }
            /// 订阅Subscription和 订阅者subscriber 是 1:1 的关系。
            let subscription = ShareReplaySubscription(subscriber: subscriber, replay: replay, capacity: capacity, completion: completion, cancel: cancel(subscription:))
            subscriptions.append(subscription)
            
            /// 订阅者 和 订阅关联。
            subscriber.receive(subscription: subscription)
            
            guard subscriptions.count == 1 else {
                return
            }
            
            /// 为了接受上游数据，这里 定义了 上游的订阅者sink ， 然后对SharedReplay 的订阅者 继续传递数据。
            let sink = AnySubscriber<Publishers.SharedReplay<Upstream>.Output, Failure>(receiveSubscription: { subscription in
                                        subscription.request(.unlimited)
                                    }, receiveValue: { [weak self] (value : Output) -> Subscribers.Demand in
                                            self?.replay(value)
                                            return .none
                                    }, receiveCompletion: {  [weak self] in
                                        self?.complete(with: $0)
                                    })
            /// 这里的sink 是一个中转站的角色。 从上游接受到数据后，对 订阅List进行 再传递。
            self.upstream.subscribe(sink)
        }
        
        /// for Subscription
        private func cancel(subscription: ShareReplaySubscription<Output, Failure>) {
            guard let index = subscriptions.firstIndex(of: subscription) else { return }
            subscriptions.remove(at: index)
        }
    }
}

extension Publisher {
    func shareReplay(capacity : Int = .max) -> Publishers.SharedReplay<Self> {
        return Publishers.SharedReplay(upstream: self, capacity: capacity)
    }
}


let subject = PassthroughSubject<Int , Never>()
let publisher = subject.shareReplay(capacity: 2)

/// 思考为什么0没有被缓存？如果想缓存的话，应该怎么修改以上代码！
subject.send(0)


let subscription1 = publisher.sink(receiveCompletion: {
    print("subscription1 \($0)")
}, receiveValue: {
    print("subscription1 \($0)")
})

subject.send(1)
subject.send(2)
subject.send(3)

/// 第二个订阅者 ，将会获取到 2，3； 因为 subject.shareReplay(capacity: 2) 保留了两个缓存。
let subscription2 = publisher.sink(receiveCompletion: {
    print("subscription2 \($0)")
}, receiveValue: {
    print("subscription2 \($0)")
})
subject.send(4)
subject.send(5)
subject.send(completion: .finished)

var subscription3: AnyCancellable? = nil

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    /// 值能接受 Compete 数据。 因为 completion 是保留的。
    subscription3 = publisher.sink(receiveCompletion: {
        print("subscription3 \($0)")
    }, receiveValue: {
        print("subscription3 \($0)")
    })
}

