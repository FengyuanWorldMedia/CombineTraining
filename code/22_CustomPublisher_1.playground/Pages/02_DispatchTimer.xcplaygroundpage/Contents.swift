// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

struct DispatchTimerConfigaration {
    /// DispatchSourceTimer# 发送的 上游的 scheduler
    let queue : DispatchQueue?
    /// DispatchSourceTimer# 从订阅开始起，发送的数据的间隔
    let interval : DispatchTimeInterval
    /// DispatchSourceTimer#发送的最大延迟时间。
    let leeway : DispatchTimeInterval
    /// subscriber# 接收次数,
    let times : Subscribers.Demand
}

class DispatchTimerSubscription<S: Subscriber> : Combine.Subscription, Equatable where S.Input == DispatchTime {
    
    let configaration : DispatchTimerConfigaration
    var totalTimes : Subscribers.Demand // 外部配置的发送次数。
    var requested : Subscribers.Demand = .none /// 表示，动态调节的次数。
    var source : DispatchSourceTimer? = nil /// 发送时间动作的动作，
    var subscriber : S?
    
    init(subscriber: S, configaration : DispatchTimerConfigaration) {
        self.subscriber = subscriber
        self.configaration = configaration
        self.totalTimes = configaration.times
    }

    // Subscription
    func request(_ demand: Subscribers.Demand) {
        print("request")
        guard self.totalTimes > .none else {
            subscriber?.receive(completion: .finished)
            return
        }
        self.requested += demand ///   确定 请求过来的，希望的次数（累加）
        if source == nil , requested > .none {
            
            // Create a DispatchSourceTimer instatnce.
            let source = DispatchSource.makeTimerSource( queue: configaration.queue)
            
            source.schedule(deadline: .now() + configaration.interval , repeating: configaration.interval, leeway: configaration.leeway)
            
            source.setEventHandler { [weak self] in
                guard let self = self else {
                    return
                }
                // 最后一次
                if self.requested == .max(0) {
                    self.subscriber?.receive(completion: .finished)
                    return
                }
                
                self.requested -= .max(1)
                // 发送数据，并动态调节次数。
                if let demand = self.subscriber?.receive(.now()) {
                    self.requested += demand
                }
                
                self.totalTimes -= .max(1)
                ///
                /// 注意这里的结束点
                if self.totalTimes == .max(0) || self.totalTimes == .none {
                    self.subscriber?.receive(completion: .finished)
                }
            }
            self.source = source
            self.source?.activate() // 启动 DispatchSourceTimer
        }
    }

    // Cancellable
    func cancel() {
        print("===cancel===")
        source = nil
        subscriber = nil
    }
 
    static func == (lhs: DispatchTimerSubscription, rhs: DispatchTimerSubscription) -> Bool {
        lhs.combineIdentifier == rhs.combineIdentifier
    }
}


extension Publishers {
    /// 创建 CustomeDispatchTimer
    struct CustomeDispatchTimer : Publisher {
        
        typealias Output = DispatchTime
        typealias Failure = Never
        
        let configaration : DispatchTimerConfigaration
        
        init(configaration : DispatchTimerConfigaration) {
            self.configaration = configaration
        }
        
        func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, S.Input == DispatchTime {
            let subscription = DispatchTimerSubscription(subscriber: subscriber,
                                                         configaration: self.configaration)
            subscriber.receive(subscription: subscription)
        }
    }
    
    static func customTimer(queue : DispatchQueue? = nil ,
                             interval : DispatchTimeInterval,
                             leeway : DispatchTimeInterval = .nanoseconds(0),
                             times : Subscribers.Demand = .unlimited) -> Publishers.CustomeDispatchTimer {
        
        return Publishers.CustomeDispatchTimer(configaration : .init(queue: queue , interval: interval , leeway: leeway , times : times ))
    }
}

var set: Set<AnyCancellable> = Set()

testSample(label: "自定义  DispatchTimer") {
    let publisher = Publishers.customTimer(interval: .seconds(1), times: .max(4))

    publisher.sink(receiveCompletion: { completion in
                        switch completion {
                            case .finished:
                                  print("finished")
                            case .failure(_):
                                print("failure")
                        }
                    }, receiveValue: { value in
                        print("sink111 \(value)")
                    }).store(in: &set)
}

testSample(label: "自定义  DispatchTimer cancel") {
     let publisher = Publishers.customTimer(interval: .seconds(1), times: .max(4))

    let subcrption = publisher.sink(receiveValue: {
        print("sink222 \($0)")
    })
    subcrption.cancel()
}



