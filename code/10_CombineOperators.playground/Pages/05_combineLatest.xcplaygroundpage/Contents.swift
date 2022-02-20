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

/// combineLatest, 合并发送数据
testSample(label: "05_combineLatest") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let sourcePublisher2 = PassthroughSubject<String, Never>()
    
    sourcePublisher
        .combineLatest(sourcePublisher2)
        .sink(receiveCompletion: { completion in
            print("05_combineLatest completion:\(completion)")
        }, receiveValue: { val1, val2  in /// 第一个参数来自sourcePublisher ， 第二个参数 来自 sourcePublisher2
            print("05_combineLatest val1 : \(val1) val2 : \(val2)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher2.send("a")
    sourcePublisher.send(300) /// 既可以和a 合并，也可以和 b,c 合并。
    sourcePublisher2.send("b")
    sourcePublisher2.send("c")
    sourcePublisher.send(400)
    sourcePublisher.send(completion: .finished)
}
