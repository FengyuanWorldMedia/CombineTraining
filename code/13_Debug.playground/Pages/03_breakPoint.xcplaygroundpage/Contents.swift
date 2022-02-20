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
testSample(label: "03_breakPoint"){
    
    enum MyErrors : Error {
        case notfound
    }
    
    let sourcePublisher = PassthroughSubject<Int, MyErrors>()
    sourcePublisher
        .breakpointOnError() /// error: Execution was interrupted, reason: signal SIGTRAP.
        .sink(receiveCompletion: { completion in
            print("03_breakPoint completion:\(completion)")
        }, receiveValue: { value in
            print("03_breakPoint value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    sourcePublisher.send(completion: .failure(.notfound))
}
 
