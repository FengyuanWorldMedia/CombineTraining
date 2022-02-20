// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

/// TODO:

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

var subscriptions = Set<AnyCancellable>()

/// zip, 一对一 合并发送数据
testSample(label: "06_zip") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let sourcePublisher2 = PassthroughSubject<String, Never>()
    
    sourcePublisher
//        .print("zipPublisher")
        .zip(sourcePublisher2)
        .sink(receiveCompletion: { completion in
            print("06_zip completion:\(completion)")
        }, receiveValue: { val1, val2  in /// 第一个参数来自sourcePublisher ， 第二个参数 来自 sourcePublisher2
            print("06_zip val1 : \(val1) val2 : \(val2)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)/// 可以和a合并。
    sourcePublisher.send(300) /// 可以和 b合并。
    sourcePublisher2.send("a")
    sourcePublisher2.send("b")
    sourcePublisher2.send("c")
    sourcePublisher.send(completion: .finished)
}
