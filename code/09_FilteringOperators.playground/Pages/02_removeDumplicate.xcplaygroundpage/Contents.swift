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

/// removeDuplicates,删除掉 相邻重复元素。
testSample(label: "01_removeDuplicates"){
    let arrPublisher = [10,10,200,11,20,11].publisher
    arrPublisher
        //.print("removeDuplicates")
        .removeDuplicates()
        .sink(receiveCompletion: { completion in
            print("     01_removeDuplicates completion:\(completion)")
        }, receiveValue: { value in
            print("     01_removeDuplicates value : \(value)")
        }).store(in: &subscriptions)
}

/// removeDuplicates：by,删除掉 相邻重复元素，判断逻辑 为 相差为5以内的认为为重复。
testSample(label: "01_removeDuplicates02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let removeDuplicatesPublisher = sourcePublisher
        // .print("filter")
        .removeDuplicates(by: {
            val1, currentValue in
            // print("val1:\(val1)  currentValue:\(currentValue)")
            let diff = val1 - currentValue
            if abs(diff) < 5 {
                return true
            } else {
                return false
            }
        })
        .sink(receiveCompletion: { completion in
            print("     01_removeDuplicates02 completion:\(completion)")
        }, receiveValue: { value in
            print("     01_removeDuplicates02 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(52) // 过滤掉
    sourcePublisher.send(10)
    sourcePublisher.send(11) // 过滤掉
    sourcePublisher.send(20)
    sourcePublisher.send(200)
    sourcePublisher.send(completion: .finished)
}
