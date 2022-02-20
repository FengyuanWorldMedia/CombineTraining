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
///first 获取发布的第一个元素
testSample(label: "03_First") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .first()
        .sink(receiveCompletion: { completion in
            print("03_First completion:\(completion)")
        }, receiveValue: { minValue in
            print("03_First first value : \(minValue)")
        }).store(in: &subscriptions)
    
 
    sourcePublisher.send("First")
    sourcePublisher.send("Second")
    sourcePublisher.send("Third")
    sourcePublisher.send(completion: .finished)
}

/// first 条件 获取发布的第一个元素
testSample(label: "03_First") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
    .first(where: { "you are the Third one.".contains($0) }) // $0 代表where回调的 参数，也就是 发布的 数据。
    .sink(receiveCompletion: { completion in
        print("03_First completion:\(completion)")
    }, receiveValue: { minValue in
        print("03_First first value : \(minValue)")
    }).store(in: &subscriptions)
    sourcePublisher.send("First")
    sourcePublisher.send("Second")
    sourcePublisher.send("Third")
    sourcePublisher.send(completion: .finished)
}
