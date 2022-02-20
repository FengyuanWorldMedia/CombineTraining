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

/// 数值最大值，数据由数组的publisher产生。
testSample(label: "02_Max"){
    let arrPublisher = [100,200,300,20,14].publisher
    arrPublisher
        .max()
        .sink(receiveCompletion: { completion in
            print("02_Max completion:\(completion)")
        }, receiveValue: { minValue in
            print("02_Max max value : \(minValue)")
        }).store(in: &subscriptions)
}

/// 数值最大值， 数据由sourcePublisher发布者产生。
testSample(label: "02_Max02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        .max()
        .sink(receiveCompletion: { completion in
            print("02_Max02 completion:\(completion)")
        }, receiveValue: { maxValue in
            print("02_Max02 max value : \(maxValue)")
        }).store(in: &subscriptions)

    sourcePublisher.send(55)
    sourcePublisher.send(200)
    sourcePublisher.send(300)
    sourcePublisher.send(200)
    // 这个是一定要有的，否则大 不会效果；认为输入没有完成，无法获取最大值。
    sourcePublisher.send(completion: .finished)
}

/// 逻辑最大值
testSample(label: "02_Max03") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .max(by: { val1, val2 in
           let result = val1.count < val2.count /// bug
           print("result:\(result)")
           return result
        })
        .sink(receiveCompletion: { completion in
            print("02_Max03 completion:\(completion)")
        }, receiveValue: { maxValue in
            print("02_Max03 max value : \(maxValue)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send("Hello")
    sourcePublisher.send("Hell454545")
    sourcePublisher.send("Hello12")
    sourcePublisher.send("Hel")
    // 这个是一定要有的，否则大 不会效果；认为输入没有完成，无法获取最大值。
    sourcePublisher.send(completion: .finished)
}
