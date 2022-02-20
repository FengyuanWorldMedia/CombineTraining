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

// prefix 将会把200,201 过滤掉
testSample(label: "07_prefix"){
    let arrPublisher = [10,11,200,201].publisher
    arrPublisher
        //.print("prefix")
        .prefix(2)
        .sink(receiveCompletion: { completion in
            print("     prefix completion:\(completion)")
        }, receiveValue: { value in
            print("     prefix value : \(value)")
        }).store(in: &subscriptions)
}

// prefix:while 将会把200,201 过滤掉
testSample(label: "07_prefix_01"){
    let arrPublisher = [15,12,11,200,11,201].publisher
    arrPublisher
       // .print("prefix")
        .prefix(while: {
            return $0 < 15
        })
        .sink(receiveCompletion: { completion in
            print("     prefix completion:\(completion)")
        }, receiveValue: { value in
            print("     prefix value : \(value)")
        }).store(in: &subscriptions)
}
 
// prefix:untilOutputFrom 停止接受信号, 示例中的 4，5 将不被接收。
testSample(label: "07_prefix_02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let readyPublisher = PassthroughSubject<Void, Never>() /// 发送事件时， 停止接收。
    
    sourcePublisher
        .prefix(untilOutputFrom: readyPublisher)
        .sink(receiveCompletion: { completion in
            print("     prefix completion:\(completion)")
        }, receiveValue: { value in
            print("     prefix value : \(value)")
        }).store(in: &subscriptions)
    
    (1...5).forEach({ c in
        sourcePublisher.send(c)
        if c == 3 {
            readyPublisher.send()
        }
    })
}
