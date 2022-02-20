// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

//: [Previous](@previous)

import Foundation
import Combine
/// 这是一个演示代码的区域，目的是为了不让变量重名
/// - Parameters:
///   - label: 演示代码描述
///   - testBlock: 演示代码
public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

testSample(label: "typeErasure sample1" ) {
 
    let subject = PassthroughSubject<String, Never>()
    
    let publisher = subject.eraseToAnyPublisher()
    
    publisher.sink(receiveCompletion: { completion in
        /// Subscribers.Completion<Self.Failure>
        switch(completion) {
            case .finished :
                print("receiveCompletion (sink) finished.")
            case .failure(let error) :
            print("receiveCompletion error (sink) : \(error)")
        }
        
    }, receiveValue: { value in
        print("receiveValue (sink) : \(value)")
    })
    
    // OK subject.send("hello")
    subject.send("hello")
    // NG publisher.send("hello")
}
