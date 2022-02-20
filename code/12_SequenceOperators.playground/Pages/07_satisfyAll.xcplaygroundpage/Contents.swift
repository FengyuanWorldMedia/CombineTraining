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
///allSatisfy 判断 发布数据是否 全部满足 指定条件。
testSample(label: "07_satisfyAll") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .allSatisfy({
            value in
            return value.hasPrefix("test")
        })
        .sink(receiveCompletion: { completion in
            print("07_satisfyAll completion:\(completion)")
        }, receiveValue: { value in
            print("07_satisfyAll value : \(value)") // allSatisfy通过验证 value 为true,否则false。
        }).store(in: &subscriptions)
    
    sourcePublisher.send("testFirst11")
    sourcePublisher.send("testSecond12")
    sourcePublisher.send("testThird12")
    sourcePublisher.send(completion: .finished)
}

///tryAllSatisfy 判断 发布数据是否 全部满足 指定条件。
///理解try概念，就是有可能产生异常，并且在 receiveCompletion 中接收。
testSample(label: "07_satisfyAll") {
    enum ParsingError: Error {
        case NotEqualToTestSecond12
    }
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .tryAllSatisfy({
            value in
            guard value == "testSecond12" else {
                throw ParsingError.NotEqualToTestSecond12
            }
            return true
        })
        .sink(receiveCompletion: { completion in
            print("07_satisfyAll completion:\(completion)") // 输出Error信息。
        }, receiveValue: { value in
            print("07_satisfyAll value : \(value)") // allSatisfy通过验证 value 为true,否则false。
        }).store(in: &subscriptions)
    
    sourcePublisher.send("testFirst11")
    sourcePublisher.send("testSecond12")
    sourcePublisher.send("testThird12")
    sourcePublisher.send(completion: .finished)
}
