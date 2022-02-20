// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

//: [Previous](@previous)


import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

class MySubject<Output, Failure : Error> : Combine.Subject {
    var value: Output {
        didSet {
            // 如果没有结束的话，每个订阅都要通知。
            guard completion == nil else { return }
            subscriptions.forEach { $0.receiveForSubject(value) }
        }
    }
    private var completion: Subscribers.Completion<Failure>? {
        didSet {
            // 控制不发生二次完了通知。
            guard oldValue == nil, let completion = completion else { return }
            subscriptions.forEach { $0.receiveForSubject(completion: completion) }
        }
    }
    
    // 订阅数组
    private var subscriptions: [MySubjectSubscription<Output, Failure>] = []

    init(_ value: Output) {
        self.value = value
    }

    // Publisher ；产生订阅。
    func receive<S>(subscriber: S) where S : Combine.Subscriber, Failure == S.Failure, Output == S.Input {
        
        let subscription = MySubjectSubscription(subscriber: subscriber, cancel: cancel(subscription:))
        subscriber.receive(subscription: subscription)
        
        subscriptions.append(subscription)

        if let completion = completion {
            // 如果结束，立即通知。
            subscription.receiveForSubject(completion: completion)
        } else {
            // 发送通知，最后一次的 当前值。
            subscription.receiveForSubject(value)
        }
    }

    // Subject
    func send(_ value: Output) {
        guard completion == nil else { return }
        self.value = value
    }
    
    func send(completion: Subscribers.Completion<Failure>) {
        self.completion = completion
    }
    
    /// This call provides the ``Subject`` an opportunity to establish demand for any new upstream subscriptions.
    /// 被CombineFW使用。
    func send(subscription: Combine.Subscription) {
        subscription.request(.unlimited)
    }
    
    // for Subscription
    private func cancel(subscription: MySubjectSubscription<Output, Failure>) {
        guard let index = subscriptions.firstIndex(of: subscription) else { return }
        subscriptions.remove(at: index)
    }
}


class MySubjectSubscription<Output, Failure : Error> : Combine.Subscription, Equatable {
    
    private var demand: Subscribers.Demand = .none
    private var subscriber: AnySubscriber<Output, Failure>
    private var cancelSubscription: (MySubjectSubscription<Output, Failure>) -> Void

    init<S>(subscriber: S, cancel: @escaping (MySubjectSubscription<Output, Failure>) -> Void) where S : Combine.Subscriber, Output == S.Input, Failure == S.Failure {
        self.subscriber = .init(subscriber)
        self.cancelSubscription = cancel
    }

    // Subscription
    func request(_ demand: Subscribers.Demand) {
        // 每次发生订阅的时候，会执行一次。
        self.demand = demand
    }

    // Cancellable, 从 订阅List删除本身。 初始化的时候，将使用MySubject#cancel 进行实现。
    func cancel() {
        cancelSubscription(self)
    }

    // for Subscriber, 在 MySubject 中调用。
    func receiveForSubject(_ value: Output) {
        guard demand != .none else { return }
        demand -= 1
        demand += subscriber.receive(value)
    }
    // for Subscriber, 在 MySubject 中调用。
    func receiveForSubject(completion: Subscribers.Completion<Failure>) {
        subscriber.receive(completion: completion)
    }

    static func == (lhs: MySubjectSubscription<Output, Failure>, rhs: MySubjectSubscription<Output, Failure>) -> Bool {
        lhs.combineIdentifier == rhs.combineIdentifier
    }
}



//let publisher = Publishers.Sequence<[Int], Error>(sequence: [0, 1, 2])
let ms: MySubject<Int, Error> = .init(11)
//
//publisher.subscribe(ms)

ms.sink(receiveCompletion: { completion in
    /// Subscribers.Completion<Self.Failure>
    switch(completion) {
        case .finished :
            print("receiveCompletion (sink1) finished.")
        case .failure(let error) :
        print("receiveCompletion error (sink1) : \(error)")
    }
}, receiveValue: { value in
    print("receiveValue (sink1) : \(value)")
})

ms.sink(receiveCompletion: { completion in
    /// Subscribers.Completion<Self.Failure>
    switch(completion) {
        case .finished :
            print("     receiveCompletion (sink2) finished.")
        case .failure(let error) :
        print("     receiveCompletion error (sink2) : \(error)")
    }
}, receiveValue: { value in
    print("     receiveValue (sink2) : \(value)")
})


ms.send(1)
ms.send(2)
ms.send(3)
ms.send(completion: .finished)
ms.sink(receiveCompletion: { completion in
    /// Subscribers.Completion<Self.Failure>
    switch(completion) {
        case .finished :
            print("     receiveCompletion (sink3) finished.")
        case .failure(let error) :
        print("     receiveCompletion error (sink3) : \(error)")
    }
}, receiveValue: { value in
    print("     receiveValue (sink3) : \(value)")
})
ms.send(2)
ms.send(3)
