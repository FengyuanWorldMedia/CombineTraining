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
testSample(label: "02_SetFailureType"){
    
    enum MyErrors: Error {
        case wrongValue
    }
    
    let sourcePublisher = PassthroughSubject<Int, Never>()
    
    let errorPublisher = sourcePublisher
        //.print("debugInfo")
        .setFailureType(to: MyErrors.self) /// 把错误的类型转变 PassthroughSubject<Int, MyErrors>
        .eraseToAnyPublisher()
    
    errorPublisher.sink(receiveCompletion: { completion in
            print("02_SetFailureType completion:\(completion)")
        }, receiveValue: { value in
            print("02_SetFailureType value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
}

testSample(label: "02_SetFailureType"){
     let pub1 = [0, 1, 2, 3, 4, 5].publisher
     let pub2 = CurrentValueSubject<Int, Error>(0)
     pub1
         .setFailureType(to: Error.self) /// 统一错误类型后，才可以combineLatest
         .combineLatest(pub2)
         .sink(
             receiveCompletion: { print ("completed: \($0)") },
             receiveValue: { print ("value: \($0)")}
          )
}
 
