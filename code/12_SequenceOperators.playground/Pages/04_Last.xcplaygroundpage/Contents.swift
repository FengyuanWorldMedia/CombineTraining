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
///last 获取发布的最后一个元素
testSample(label: "04_Last") {
    let sourcePublisher = PassthroughSubject<String, Never>()
   sourcePublisher
        .last()
        .sink(receiveCompletion: { completion in
            print("04_Last completion:\(completion)")
        }, receiveValue: { value in
            print("04_Last last value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send("First")
    sourcePublisher.send("Second")
    sourcePublisher.send("Third")
    sourcePublisher.send(completion: .finished)
}

/// last 条件 获取发布的最后一个元素
testSample(label: "04_Last") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .last(where: { "you are the First one.".contains($0) }) // $0 代表where回调的 参数，也就是 发布的 数据。
        .sink(receiveCompletion: { completion in
            print("04_Last completion:\(completion)")
        }, receiveValue: { value in
            print("04_Last last value : \(value)")
        }).store(in: &subscriptions)
    sourcePublisher.send("First")
    sourcePublisher.send("Second")
    sourcePublisher.send("Third")
    sourcePublisher.send("one")
    sourcePublisher.send(completion: .finished)
}
