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
///contains 判断 发布数据是否出现在发布数据 一览中。
testSample(label: "06_Contains") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .contains("Second12") /// 参数遵循Equatable 协议,且 参数类型和 发布类型一致。
        .sink(receiveCompletion: { completion in
            print("06_Contains completion:\(completion)")
        }, receiveValue: { value in
            print("06_Contains value : \(value)") // 如果出现在发布数据中的话（协议Equatable判断相等的情况），value 为true,否则false。
        }).store(in: &subscriptions)
    
    sourcePublisher.send("First11")
    sourcePublisher.send("Second12")
    sourcePublisher.send("Third12")
    sourcePublisher.send(completion: .finished)
}

///contains：where 判断 发布数据是否出现在发布数据 一览中。
testSample(label: "06_Contains2") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .contains(where: {
            value in
            return value.count == 7 && value.contains("T")
        })
        .sink(receiveCompletion: { completion in
            print("06_Contains2 completion:\(completion)")
        }, receiveValue: { value in
            print("06_Contains2 value : \(value)") // 如果出现在发布数据中的话，value 为true,否则false。
        }).store(in: &subscriptions)
    sourcePublisher.send("First12")
    sourcePublisher.send("Second13")
    sourcePublisher.send("Third14") // 对象
    sourcePublisher.send("Forth15")
    sourcePublisher.send(completion: .finished)
}
