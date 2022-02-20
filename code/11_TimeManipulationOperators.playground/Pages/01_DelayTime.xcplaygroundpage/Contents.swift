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

// collectPublisher 在sourcePublisher 一秒后，开发发送数据。
testSample(label: "01_DelayTime"){
    
    let sourcePublisher = PassthroughSubject<Date, Never>()
    
    sourcePublisher.delay(for: .seconds(1) , scheduler : DispatchQueue.main)
                                        .sink(receiveCompletion: { completion in
                                            print("     delayPublisher completion:\(completion)")
                                        }, receiveValue: { date in
                                            print("     delayPublisher receiveValue: \(date.timeIntervalSinceReferenceDate.description)")
                                        }).store(in: &subscriptions)

    sourcePublisher.sink(receiveCompletion: { completion in
        print("sourcePublisher completion:\(completion)")
    }, receiveValue: { date in
        print("sourcePublisher receiveValue: \(date.timeIntervalSinceReferenceDate.description)")
    }).store(in: &subscriptions)
    
    print("now : \(Date().timeIntervalSinceReferenceDate.description)")
    /// 理解为什么Timer 和 PassthroughSubject 结合， 数据类型 要一致 为Date
    Timer.publish(every: 1.0, on: .main, in: .common)
                        .autoconnect()
                        .subscribe(sourcePublisher)
                        .store(in: &subscriptions)
}
  
