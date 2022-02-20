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

/// apend, 在数组后添加元素
testSample(label: "02_append"){
    let arrPublisher = [100,200,300,20,14].publisher
    arrPublisher
        .append(2,4)
        .sink(receiveCompletion: { completion in
            print("02_apend completion:\(completion)")
        }, receiveValue: { value in
            print("02_apend value : \(value)")
        }).store(in: &subscriptions)
}

/// prepend, 在数组后添加元素， 数据由sourcePublisher发布者产生。
/// 参数为可变长，类型和Output一致
testSample(label: "02_append02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        .append(20,40,50)
        .sink(receiveCompletion: { completion in
            print("02_append02 completion:\(completion)")
        }, receiveValue: { value in
            print("02_append02 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(200)
    sourcePublisher.send(300)
    sourcePublisher.send(200)
    sourcePublisher.send(completion: .finished)
}
 
/// prepend, 在数组后添加元素， 数据由sourcePublisher发布者产生。
/// 参数为 素组，类型和Output一致
testSample(label: "02_append03") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        .append([21,41,51])
        .sink(receiveCompletion: { completion in
            print("02_append03 completion:\(completion)")
        }, receiveValue: { value in
            print("02_append03 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(200)
    sourcePublisher.send(completion: .finished)
}

/// prepend, 在数组后添加元素， 数据由sourcePublisher发布者产生。
/// 参数为publisher
testSample(label: "02_append04") {
    
    let arrPublisher = [99,100].publisher
    
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        .append(arrPublisher)
        .sink(receiveCompletion: { completion in
            print("02_append04 completion:\(completion)")
        }, receiveValue: { value in
            print("02_append04 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(200)
    sourcePublisher.send(completion: .finished) /// 结束标识，append 起效。
}

/// prepend, 在数组前添加元素， 数据由sourcePublisher发布者产生。
/// 参数为publisher
testSample(label: "02_append05") {
    
    let arrPublisher = PassthroughSubject<Int, Never>()
    
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        .append(arrPublisher)
        .sink(receiveCompletion: { completion in
            print("02_append05 completion:\(completion)")
        }, receiveValue: { value in
            print("02_append05 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(200)
    /// 这一个非常重要，它意味着sourcePublisher 已经结束，后续的 arrPublisher 才可以继续发布数据；否则后续 收不到。
    sourcePublisher.send(completion: .finished)
    arrPublisher.send(100)
    arrPublisher.send(200)
    arrPublisher.send(completion: .finished)
}
