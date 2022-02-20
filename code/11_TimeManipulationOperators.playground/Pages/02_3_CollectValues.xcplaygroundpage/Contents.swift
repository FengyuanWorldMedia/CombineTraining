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

//sourcePublisher 一秒一次； 但是 每隔4秒 发送一次，或者满足件数2个时候 也发送。
//Timer 设置为1 每个一秒发布一个数据的话，刚开始不发送数据，1秒后 发送数据，灰色的 代表 起始。
//其中3号 和 7号是 满足 件数2 的情况，同时7号 也满足 每个4秒的情况。
testSample(label: "02_3_CollectValues"){
    let sourcePublisher = PassthroughSubject<Date, Never>()
    sourcePublisher.collect(.byTimeOrCount(DispatchQueue.main, .seconds(4), 2))
                                        .flatMap { dates in
                                            dates.publisher
                                        }.sink(receiveCompletion: { completion in
                                            print("         delayPublisher completion:\(completion)")
                                        }, receiveValue: { date in
                                            print("         delayPublisher receiveValue: \(date)")
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
 
