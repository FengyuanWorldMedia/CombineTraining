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

/// print 进行Debug信息输出。
testSample(label: "02_append"){
    let arrPublisher = [100,200,300,20,14].publisher
    arrPublisher
        .print("")
        .sink(receiveCompletion: { completion in
            print("02_apend completion:\(completion)")
        }, receiveValue: { value in
            print("02_apend value : \(value)")
        }).store(in: &subscriptions)
}

/// 解释一下Log信息：
//您正在演示:02_append
//debugInfo: receive subscription: ([100, 200, 300, 20, 14])
//debugInfo: request unlimited
//debugInfo: receive value: (100)
//02_apend value : 100
//debugInfo: receive value: (200)
//02_apend value : 200
//debugInfo: receive value: (300)
//02_apend value : 300
//debugInfo: receive value: (20)
//02_apend value : 20
//debugInfo: receive value: (14)
//02_apend value : 14
//debugInfo: receive finished
//02_apend completion:finished
//演示:02_append结束
