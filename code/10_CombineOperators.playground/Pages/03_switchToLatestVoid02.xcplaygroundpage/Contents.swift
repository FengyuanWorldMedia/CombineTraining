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

/// switchToLatest, 是多个 Publisher 发布事件后，只有最新事件的被处理。
/// 利用这样的机制，可以模拟在 多个task串行进行的情况下，如果下一个任务开始后，之前的可以停掉（或者在合适的时间点【安全】停掉）。
/// 比如：网页的内容下载等。
testSample(label: "03_switchToLatestVoid02") {
    /// 注意这里的定义，Output为PassthroughSubject<Void, Never>
    let publishers = PassthroughSubject<PassthroughSubject<Void, Never>, Never>()
    
    let aPublisher = PassthroughSubject<Void, Never>()
    let bPublisher = PassthroughSubject<Void, Never>()
    let cPublisher = PassthroughSubject<Void, Never>()
     
    publishers
        .switchToLatest()
        .sink(receiveCompletion: { completion in
            print("03_switchToLatest02 completion:\(completion)")
        }, receiveValue: { value in
            print("03_switchToLatest02 value : \(value)")
        }).store(in: &subscriptions)
    
    publishers.send(aPublisher)
    aPublisher.send()
    aPublisher.send()
    
    publishers.send(bPublisher)
    aPublisher.send() // 已经切换到bPublisher；aPublisher 的发布事件不再被接受。
    bPublisher.send()
    bPublisher.send()
    
    publishers.send(cPublisher)
    bPublisher.send() // 已经切换到cPublisher；bPublisher 的发布数据不再被接受。
    cPublisher.send()
    cPublisher.send()
    
    // 结束当前的publisher发送数据，这个是可选的，当前的 publisher结束不会引起 03_switchToLatest completion。
    cPublisher.send(completion: .finished)
    // 结束容器 publishers发送数据。
    publishers.send(completion: .finished)
}
