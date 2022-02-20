// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

public func printInfo( _ o : Any) {
    print(o)
}

/// 扩展了PassthroughSubject,模拟输入。
extension PassthroughSubject {
    func feed(with input: [(TimeInterval , Output)]) {
        for e in input {
            Timer.scheduledTimer(withTimeInterval: e.0, repeats: false, block : { timer in
//                printInfo(" scheduledTimer : \(Date().timeIntervalSince1970)")
                self.send(e.1)
            })
        }
    }
}

var subscriptions = Set<AnyCancellable>()

testSample(label: "TimerTest"){
    
    let subject = PassthroughSubject<String, Never>()
    
    // throttle 是，在一秒之后，发送的数据是subject的 制定时间区间内的（ 1秒内）的 第一个（latest: false）, 或者 最后一个（latest: true）  。
    let throttle = subject.throttle(for: .seconds(1.0), scheduler: DispatchQueue.main, latest: true).share()
    
    subject.sink(receiveCompletion: { completion in
                print("subject completion:\(completion)")
            }, receiveValue: { value in
//                print(" \(Date().timeIntervalSince1970)")
                print("subject receiveValue: \(value)")
            }).store(in: &subscriptions)
   

    throttle.sink(receiveCompletion: { completion in
        print("     throttle completion:\(completion)")
    }, receiveValue: { value in
        print("      \(Date().timeIntervalSince1970)")
        print("     throttle receiveValue: \(value)")
    }).store(in: &subscriptions)
    
    // 模拟检索框 输入值。
    let input : [(TimeInterval ,String)] = [
        (0.0, "y"),
        (0.1, "yo"),
        (0.2, "you"),
        (0.3, "your"),
        (1.5, "your "),// 表示 停顿1秒后，产生debounce 发送
        (1.6, "your b"),
        (1.7, "your bo"),
        (2.3, "your boy"),// 表示 停顿1秒后，产生debounce 发送
    ]
     print("now : \(Date().timeIntervalSince1970)")
     subject.feed(with: input)
}
 
