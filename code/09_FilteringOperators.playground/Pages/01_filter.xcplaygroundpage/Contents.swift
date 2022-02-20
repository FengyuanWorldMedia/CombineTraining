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

/// filter, 过滤数组中 小于 30 的数据
testSample(label: "01_filter"){
    let arrPublisher = [10,200,300,20,14].publisher
    arrPublisher
        //.print("filter")
        .filter({ ele in
            return ele < 30
        })
        .sink(receiveCompletion: { completion in
            print("01_filter completion:\(completion)")
        }, receiveValue: { value in
            print("01_filter value : \(value)")
        }).store(in: &subscriptions)
}

/// filter, PassthroughSubject 中 小于 30 的数据
testSample(label: "01_filter02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let filterPublisher = sourcePublisher
        //.print("filter")
        .filter({ ele in
            return ele < 30
        })
        .sink(receiveCompletion: { completion in
            print("01_filter02 completion:\(completion)")
        }, receiveValue: { value in
            print("01_filter02 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(10)
    sourcePublisher.send(20)
    sourcePublisher.send(200)
    sourcePublisher.send(completion: .finished)
}
 
