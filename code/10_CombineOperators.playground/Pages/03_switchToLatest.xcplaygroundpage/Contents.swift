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
 
/// switchToLatest, 是多个 Publisher 发布数据后，只有最新的被处理。
testSample(label: "03_switchToLatest") {
    /// 注意这里的定义，Output为PassthroughSubject<Int, Never>
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
    
    let aPublisher = PassthroughSubject<Int, Never>()
    let bPublisher = PassthroughSubject<Int, Never>()
    let cPublisher = PassthroughSubject<Int, Never>()
     
    publishers
//        .print("publishers")
        .switchToLatest()
        .sink(receiveCompletion: { completion in
            print("03_switchToLatest completion:\(completion)")
        }, receiveValue: { value in
            print("03_switchToLatest value : \(value)")
        }).store(in: &subscriptions)
    
    publishers.send(aPublisher)
    aPublisher.send(1)
    aPublisher.send(2)
    
    publishers.send(bPublisher)
    aPublisher.send(3) // 已经切换到bPublisher；aPublisher 的发布数据不再被接受。
    bPublisher.send(4)
    bPublisher.send(5)
    
    publishers.send(cPublisher)
    bPublisher.send(6) // 已经切换到cPublisher；bPublisher 的发布数据不再被接受。
    cPublisher.send(7)
    cPublisher.send(8)
    
    // 结束当前的publisher发送数据，这个是可选的，当前的 publisher结束不会引起 03_switchToLatest completion。
    cPublisher.send(completion: .finished)
    
    // 结束容器 publishers发送数据。
    publishers.send(completion: .finished)
}
