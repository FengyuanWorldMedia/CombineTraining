// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

var subscriptions = Set<AnyCancellable>()

/// print 进行Debug信息输出。
testSample(label: "03_breakPoint02"){
    
    enum MyErrors : Error {
        case notfound
    }
    
    let sourcePublisher = PassthroughSubject<Int, MyErrors>()
    sourcePublisher
        // .breakpoint(receiveSubscription: <#T##((Subscription) -> Bool)?##((Subscription) -> Bool)?##(Subscription) -> Bool#>, receiveOutput: <#T##((Int) -> Bool)?##((Int) -> Bool)?##(Int) -> Bool#>, receiveCompletion: <#T##((Subscribers.Completion<MyErrors>) -> Bool)?##((Subscribers.Completion<MyErrors>) -> Bool)?##(Subscribers.Completion<MyErrors>) -> Bool#>)
        .breakpoint( receiveOutput: {
            output in
            if output == 2 {
                return true
            } else {
                return false
            }
        })
        .sink(receiveCompletion: { completion in
            print("03_breakPoint02 completion:\(completion)")
        }, receiveValue: { value in
            print("03_breakPoint02 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2) /// error: Execution was interrupted, reason: signal SIGTRAP.
    sourcePublisher.send(completion: .failure(.notfound))
}
 
//// breakpoint 的参数说明
