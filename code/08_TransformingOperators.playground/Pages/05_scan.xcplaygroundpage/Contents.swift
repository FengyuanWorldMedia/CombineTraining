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
/// 05_scan, 合并
/// scan(0) { newVal , currVal in
/// 其中参数为初始值，newVal 为上次的 “积累”计算的值，currVal 为当前发布的值。
/// 和reduce不同的是，scan每次计算的 的结果都会被 订阅者接收到。而reduce 只有最后的结果。
testSample(label: "05_scan") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
     sourcePublisher
        .scan(0) { currVal , sumValue in
            print("\(currVal):\(sumValue)")
            return currVal + sumValue
        }
        .sink(receiveCompletion: { completion in
            print("05_scan completion:\(completion)")
        }, receiveValue: { val1  in
            print("05_scan val1 : \(val1) ")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    sourcePublisher.send(3)
    sourcePublisher.send(completion: .finished)
}

testSample(label: "05_reduce") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
     sourcePublisher
        .reduce(0, { currVal , sumValue in
            return currVal + sumValue
        })
        .sink(receiveCompletion: { completion in
            print("05_scan completion:\(completion)")
        }, receiveValue: { val1  in
            print("05_scan val1 : \(val1) ")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    sourcePublisher.send(3)
    sourcePublisher.send(completion: .finished)
}
