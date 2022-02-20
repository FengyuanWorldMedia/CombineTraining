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

/// 数值最小值，数据由数组的publisher产生。
testSample(label: "01_Min"){
    let arrPublisher = [100,200,300,20,14].publisher
    arrPublisher
        //.print("arrPublisher")
        .min()
        .sink(receiveCompletion: { completion in
            print("01_Min completion:\(completion)")
        }, receiveValue: { minValue in
            print("01_Min min value : \(minValue)")
        }).store(in: &subscriptions)
}

/// 数值最小值， 数据由sourcePublisher发布者产生。
testSample(label: "01_Min02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
       // .print("minPublisher")
        .min()
        .sink(receiveCompletion: { completion in
            print("01_Min02 completion:\(completion)")
        }, receiveValue: { minValue in
            print("01_Min02 min value : \(minValue)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(200)
    sourcePublisher.send(300)
    sourcePublisher.send(200)
    // 这个是一定要有的，否则min 不会效果；认为输入没有完成，无法获取最小值。
    sourcePublisher.send(completion: .finished)
}

/// 逻辑最小值,如果Output类型 中如果不实现 Comparable协议，那么就使用 min:by.
testSample(label: "01_Min03") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    sourcePublisher
        .min(by: { val1, val2 in
             print("val1 :\(val1) ---- val2 :\(val2)")
            let result = val1.count > val2.count
            print("result:\(result)")
            return result
        })
        .sink(receiveCompletion: { completion in
            print("01_Min03 completion:\(completion)")
        }, receiveValue: { minValue in
            print("01_Min03 min value : \(minValue)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send("Hello world")
    sourcePublisher.send("Hello")
    sourcePublisher.send("Hello2")
    sourcePublisher.send("Hello31")
    // 这个是一定要有的，否则min 不会效果；认为输入没有完成，无法获取最小值。
    sourcePublisher.send(completion: .finished)
}


// Increasing Order : [Hello ,Hello2,  Hello31, Hello world]
