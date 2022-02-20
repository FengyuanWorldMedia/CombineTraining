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

/// merge, 合并发送数据
testSample(label: "04_merge") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let sourcePublisher2 = PassthroughSubject<Int, Never>()
    
    sourcePublisher
//        .print("mergePublisher")
        .merge(with: sourcePublisher2)
        .sink(receiveCompletion: { completion in
            print("04_merge completion:\(completion)")
        }, receiveValue: { value in
            print("04_merge value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher2.send(200)
    sourcePublisher.send(300)
    sourcePublisher2.send(200)
    sourcePublisher2.send(201)
    sourcePublisher.send(completion: .finished)
    sourcePublisher2.send(completion: .finished) // 注意点：sourcePublisher2的结束信息，接收不到。
}
