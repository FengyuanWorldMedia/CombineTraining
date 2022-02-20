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

/// collect, 一次性获取所有的元素。
testSample(label: "01_Collect"){
    let arrPublisher = [100,200,300,20,14].publisher
    arrPublisher
        //.print("arrPublisher")
        .collect()
        .sink(receiveCompletion: { completion in
            print("01_Collect completion:\(completion)")
        }, receiveValue: { value in
            print("01_Collect value : \(value)")
        }).store(in: &subscriptions)
}

/// collect, 获取指定的 元素个数。
testSample(label: "01_Collect02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let collectPublisher = sourcePublisher
        //.print("collectPublisher")
        .collect(3)
        .sink(receiveCompletion: { completion in
            print("01_Collect02 completion:\(completion)")
        }, receiveValue: { value in
            print("01_Collect02 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(200)
    sourcePublisher.send(300)
    sourcePublisher.send(200)
    sourcePublisher.send(completion: .finished)
}
 
/// collect, 指定的时间 获取已经发送的 元素。
testSample(label: "01_Collect03") {
    /// https://hit-alibaba.github.io/interview/iOS/ObjC-Basic/Runloop.html
    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html
    /// https://newbedev.com/runloop-vs-dispatchqueue-as-scheduler
    let sub = Timer.publish(every: 1, on: RunLoop.current, in: .default)
                .autoconnect()
                .collect(.byTime(RunLoop.main, .seconds(5)))
                .sink { print("\($0)", terminator: "\n\n") }
                .store(in: &subscriptions)
}
