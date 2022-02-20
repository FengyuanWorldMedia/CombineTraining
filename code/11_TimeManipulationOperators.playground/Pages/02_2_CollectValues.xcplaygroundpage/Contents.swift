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

// sourcePublisher 一秒一次； 但是 每隔4秒 collect 连续走4次； 此时 collectPublisher 是连续发送4次。
testSample(label: "02_2_CollectValues"){
    let sourcePublisher = PassthroughSubject<Date, Never>()
    
    sourcePublisher.collect(.byTime(DispatchQueue.main, .seconds(4)))
                                        .flatMap { dates in
                                            dates.publisher
                                        }.sink(receiveCompletion: { completion in
                                            print("     collectPublisher completion:\(completion)")
                                        }, receiveValue: { date in
                                            print("     collectPublisher receiveValue: \(date)")
                                        }).store(in: &subscriptions)

    
    sourcePublisher.sink(receiveCompletion: { completion in
        print("sourcePublisher completion:\(completion)")
    }, receiveValue: { date in
        print("sourcePublisher receiveValue: \(date)")
    }).store(in: &subscriptions)
    
    
    print("now : \(Date())")
    Timer.publish(every: 1.0, on: .main, in: .common)
                        .autoconnect()
                        .subscribe(sourcePublisher)
                        .store(in: &subscriptions)
}
 
