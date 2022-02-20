// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

/// 扩展了PassthroughSubject,模拟输入。
extension PassthroughSubject {
    func feed(with input: [(Double , Output)]) {
        let now = DispatchTime.now()
        for e in input {
            let when = now + DispatchTimeInterval.milliseconds(Int(e.0*1000))
            // 这里的 asyncAfter 不能保证执行顺序；如果想保证 执行的顺序，需要设计别的机制。
            /// https://developer.apple.com/documentation/foundation/timer/2091889-scheduledtimer
            ///
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.send(e.1)
            }
        }
    }
}

var subscriptions = Set<AnyCancellable>()

testSample(label: "04_01_throttle"){
    
    let subject = PassthroughSubject<String, Never>()
    
    // throttle 是，在一秒之后，发送的数据是subject的 制定时间区间内的（ 1秒内）的 第一个（latest: false）, 或者 最后一个（latest: true）  。
    let throttle = subject.throttle(for: .seconds(1.0), scheduler: DispatchQueue.main, latest: false).share()
    
    subject.sink(receiveCompletion: { completion in
                print("subject completion:\(completion)")
            }, receiveValue: { value in
                print(" \(Date())")
                print("subject receiveValue: \(value)")
            }).store(in: &subscriptions)
   

    throttle.sink(receiveCompletion: { completion in
        print("     throttle completion:\(completion)")
    }, receiveValue: { value in
        print("      \(Date())")
        print("     throttle receiveValue: \(value)")
    }).store(in: &subscriptions)
    
    // 模拟检索框 输入值。
    let input : [(Double ,String)] = [
        (0.05, "y"),
        (0.1, "yo"),
        (0.2, "you"),
        (0.3, "your"),
        (1.5, "your "),// 表示 停顿1秒后，产生throttle 发送
        (1.6, "your b"),
        (1.7, "your bo"),
        (2.3, "your boy"),// 表示 停顿1秒后，产生throttle 发送
    ]
     print("now : \(Date())")
     subject.feed(with: input)
}
 
