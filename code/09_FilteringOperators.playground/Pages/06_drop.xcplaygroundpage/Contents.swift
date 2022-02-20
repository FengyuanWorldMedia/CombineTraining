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

// dropFirst 将会把10 过滤掉
testSample(label: "06_drop"){
    let arrPublisher = [10,11,200,201].publisher
    arrPublisher
        //.print("drop")
        .dropFirst()
        .sink(receiveCompletion: { completion in
            print("     drop completion:\(completion)")
        }, receiveValue: { value in
            print("     drop value : \(value)")
        }).store(in: &subscriptions)
}

// dropFirst(2) 将会把10,11 过滤掉
testSample(label: "06_drop_01"){
    let arrPublisher = [10,11,200,201].publisher
    arrPublisher
        //.print("drop")
        .dropFirst(2)
        .sink(receiveCompletion: { completion in
            print("     drop completion:\(completion)")
        }, receiveValue: { value in
            print("     drop value : \(value)")
        }).store(in: &subscriptions)
}

// drop:while 将会把10,11,12,14 过滤掉
testSample(label: "06_drop_02"){
    let arrPublisher = [10,11,12,14,15,200,201].publisher
    arrPublisher
        //.print("drop")
        .drop(while: {
            val in
            return val < 15 // 如果返回值为true的时候，drop操作会一直执行。
        })
        .sink(receiveCompletion: { completion in
            print("     drop completion:\(completion)")
        }, receiveValue: { value in
            print("     drop value : \(value)")
        }).store(in: &subscriptions)
}

// drop:untilOutputFrom 发送接受信号。
testSample(label: "06_drop_03") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let readyPublisher = PassthroughSubject<Void, Never>() /// 发送事件时， 才接收。
    
    sourcePublisher
        .drop(untilOutputFrom: readyPublisher)
        .sink(receiveCompletion: { completion in
            print("     drop completion:\(completion)")
        }, receiveValue: { value in
            print("     drop value : \(value)")
        }).store(in: &subscriptions)
    
    (1...5).forEach({ c in
        sourcePublisher.send(c)
        if c == 3 {
            readyPublisher.send()
        }
    })
}

// drop:untilOutputFrom 发送接受信号。讨论这种写法的错误。
testSample(label: "06_drop_04_ng"){
    let readyPublisher = PassthroughSubject<Void, Never>()
    let arrPublisher = [10,11,12,14,15,200,201].publisher
    arrPublisher
        .drop(untilOutputFrom: readyPublisher)
        .sink(receiveCompletion: { completion in
            print("     drop completion:\(completion)")
        }, receiveValue: { value in
            print("     drop value : \(value)")
            if value == 14 { // 因为receiveValue 不被接收， 所以 这里的 readyPublisher.send() 不会起效。
                print("readyPublisher.send()")
                readyPublisher.send()
            }
        }).store(in: &subscriptions)
}
