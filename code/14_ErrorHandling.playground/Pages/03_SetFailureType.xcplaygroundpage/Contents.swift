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

/// setFailureType
testSample(label: "03_SetFailureType"){
    
    enum MyErrors: Error {
        case wrongValue
    }
    
    let sourcePublisher = PassthroughSubject<Int, MyErrors>()
    
    let errorPublisher = sourcePublisher
        .print("debugInfo")
//        .setFailureType(to: MyErrors.self)
        .assertNoFailure() // 如果检测到有Error，则直接退出执行； 而不会出现在 receiveCompletion 里。 error: Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0).
        .eraseToAnyPublisher()
    
    errorPublisher.sink(receiveCompletion: { completion in
            print("03_SetFailureType completion:\(completion)")
        }, receiveValue: { value in
            print("03_SetFailureType value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    
    sourcePublisher.send(completion: .failure(.wrongValue)) /// 发布错误
}

 
