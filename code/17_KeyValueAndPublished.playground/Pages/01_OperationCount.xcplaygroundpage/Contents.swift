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

testSample(label: "01_OperationCount"){
    
    let queue = OperationQueue()
    
    let queuePublisher = queue.publisher(for: \.operationCount) /// 监视 queue#operationCount的变化，其 receiveValue 就是 operationCount
    queuePublisher 
        .sink(receiveCompletion: { completion in
            print("01_OperationCount completion:\(completion)")
        }, receiveValue: { value in
            print("01_OperationCount value : \(value)")
        }).store(in: &subscriptions)

    queue.addOperation({
        print("hello")
    })
//
    queue.addOperation({
        print("world")
    })
}
 
