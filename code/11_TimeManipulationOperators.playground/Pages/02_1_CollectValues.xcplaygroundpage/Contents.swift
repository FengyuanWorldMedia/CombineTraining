// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

/// 理解为什么 定义 subscriptions
var subscriptions = Set<AnyCancellable>()

// collectPublisher 每隔4秒collect 走一次，可以将 没有收集的数据，一起获取到； 此时 collectPublisher 是一次发送。
testSample(label: "02_1_CollectValues"){
    let sourcePublisher = PassthroughSubject<Date, Never>()
    sourcePublisher.collect(.byTime(DispatchQueue.main, .seconds(4)))
                                        .sink(receiveCompletion: { completion in
                                            print("     collectPublisher completion:\(completion)")
                                        }, receiveValue: { dates in
                                            print(dates)
                                        }).store(in: &subscriptions)

    sourcePublisher.sink(receiveCompletion: { completion in
        print("sourcePublisher completion:\(completion)")
    }, receiveValue: { date in
        print("sourcePublisher receiveValue: \(date)")
    }).store(in: &subscriptions)
    
    print("now : \(Date())")
    /// 理解为什么Timer 和 PassthroughSubject 结合， 数据类型 要一致 为Date
    Timer.publish(every: 1.0, on: .main, in: .common)
                        .autoconnect()
                        .subscribe(sourcePublisher)
                        .store(in: &subscriptions)
}
 
