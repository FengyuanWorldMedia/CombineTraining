// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.
import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("-----您正在演示:\(label)-----")
    testBlock()
    print("-----演示:\(label)结束-----")
}

///  本示例讲解 ： 自定义SubSubscriber  Subscribers.Demand 的 次数调整。
testSample(label: "Subscriber sample2" ) {

    
    final class IntSubscriber : Subscriber {
        
        // 1.设定接受的数据类型
        typealias Input = Int
        typealias Failure = Never
        
        // 2.初始的时候，设定接受的 数据次数
        func receive(subscription: Subscription) {
            // subscription.request(.max(5))
             subscription.request(.max(2))
            // subscription.request(.unlimited)
        }
        
        // 3.在每次接受数据后，重新设定希望 接受的 数据次数，总次数是 request（Subscription）方法中的设定值和receive（Output）中的总和。
        func receive(_ input: Int) -> Subscribers.Demand {
            print("receive value : \(input)")
            return .max(0)
        }
        
        // 4.接收到 结束
        func receive(completion: Subscribers.Completion<Never>) {
            print("completion : \(completion)")
        }
    }
    
    let subscriber = IntSubscriber()
    
    let publisher = CurrentValueSubject<Int, Never>(1)
    publisher.subscribe(subscriber)
    publisher.send(11)
    publisher.send(12)
    publisher.send(completion: .finished)
}
