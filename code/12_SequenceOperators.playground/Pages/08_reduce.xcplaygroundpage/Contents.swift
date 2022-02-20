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

///08_reduce 处理合并, 求和
testSample(label: "08_reduce_01") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        .reduce(100, { sum , val in  /// 理解初始值，和回调参数。
            return sum + val
        })
        .sink(receiveCompletion: { completion in
            print("08_reduce completion:\(completion)")
        }, receiveValue: { value in
            print("08_reduce value : \(value)") // reduce 的最后结果
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    sourcePublisher.send(3)
    sourcePublisher.send(completion: .finished)
}

///08_reduce 处理合并，字符串 拼接
testSample(label: "08_reduce_02") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher 
        .reduce("", { str , val in  /// 理解初始值，和回调参数。
            return str + val
        })
        .sink(receiveCompletion: { completion in
            print("08_reduce completion:\(completion)")
        }, receiveValue: { value in
            print("08_reduce value : \(value)") // reduce 的最后结果
        }).store(in: &subscriptions)
    
    sourcePublisher.send("You ")
    sourcePublisher.send("are ")
    sourcePublisher.send("handsome!")
    sourcePublisher.send(completion: .finished)
}
