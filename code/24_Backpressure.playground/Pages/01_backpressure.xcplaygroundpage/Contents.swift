// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

protocol Pausable {
    var paused: Bool { get }
    func resume()
}

final class PausableSubscriber<Input , Failure : Error>: Subscriber, Pausable, Cancellable {
    
    let receiveValue: (Input) -> Bool
    
    let receiveCompletion: (Subscribers.Completion<Failure>) -> Void
    
    private var subscription : Subscription? = nil
    
    var paused: Bool = false
    
    init(receiveValue: @escaping (Input) -> Bool, receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void) {
        self.receiveValue = receiveValue
        self.receiveCompletion = receiveCompletion
    }
    
    func cancel() {
        subscription?.cancel()
        subscription = nil
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.max(1)) // 默认可以接收一个数据。
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        if self.receiveValue(input) {
            return .max(1) /// 如果当前处理OK的话，可以再接收一个 数据。
        }
        self.paused = true
        return .none /// This is equivalent to `Demand.max(0)`. 下次不再接收
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        self.receiveCompletion(completion)
        subscription = nil
    }
    
    /// 被订阅者调用
    func resume() {
        guard paused else {
            return
        }
        paused = false
        /// 重新启动
        subscription?.request(.max(1)) /// 重新启动发送数据。 /// Tells a publisher that it may send more values to the subscriber.
    }
    
}


extension Publisher {
    /// 观察这里的订阅者，如何 声明式返回。
    func pausableSink(receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void, receiveValue: @escaping (Output) -> Bool ) -> Pausable & Cancellable {
        let pausableSink = PausableSubscriber(receiveValue: receiveValue, receiveCompletion: receiveCompletion)
        self.subscribe(pausableSink) /// 这里的self 为当前 发布者。
        return pausableSink
    }
}

let subscriber = [1,2,3,4,5,6].publisher
                        .pausableSink(receiveCompletion: { _ in
                                print("receiveCompletion")
                            }, receiveValue: { val in
                                print(" receiveValue: \(val)")
                                if val == 3 {
                                    print("pausing")
                                    return false
                                } else {
                                    return true
                                }
                            })

DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
    print("start")
    subscriber.resume()
}












