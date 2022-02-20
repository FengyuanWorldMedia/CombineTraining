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
///output:at 获取发布的指定一个元素
testSample(label: "05_output") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .output(at: 1)
        .sink(receiveCompletion: { completion in
            print("05_output completion:\(completion)")
        }, receiveValue: { value in
            print("05_output value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send("First")
    sourcePublisher.send("Second")
    sourcePublisher.send("Third")
    sourcePublisher.send(completion: .finished)
}

///output:in 获取发布的指定一组元素
testSample(label: "05_output2") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .output(in: 0...2)
        .sink(receiveCompletion: { completion in
            print("05_output2 completion:\(completion)")
        }, receiveValue: { value in
            print("05_output2 value : \(value)")
        }).store(in: &subscriptions)
    sourcePublisher.send("First") // 对象
    sourcePublisher.send("Second")// 对象
    sourcePublisher.send("Third") // 对象
    sourcePublisher.send("Forth") // 对象外
    sourcePublisher.send(completion: .finished)
}
