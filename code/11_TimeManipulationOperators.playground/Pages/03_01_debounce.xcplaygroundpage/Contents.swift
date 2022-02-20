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
            DispatchQueue.global().asyncAfter(deadline: when) {
                self.send(e.1)
            } 
        }
    }
}

var subscriptions = Set<AnyCancellable>()

testSample(label: "03_01_debounce"){
    
    let subject = PassthroughSubject<String, Never>()
    
    // debounce 是，在一秒之后，发送的数据是subject的最后一个。
    // share() 保证了 上流publisher 对所有的 订阅者来讲，产生的数据是一致的; 对于带有Mapping 逻辑的 容易产生不一致的数据，参考 03_02_debounce。
    /// Shares the output of an upstream publisher with multiple subscribers.
    let debounce = subject
                        .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
                        .share()
    
    subject.sink(receiveCompletion: { completion in
                print("subject completion:\(completion)")
            }, receiveValue: { value in
                print("subject receiveValue: \(value)")
            }).store(in: &subscriptions)
   

    debounce.sink(receiveCompletion: { completion in
        print("     debounce completion:\(completion)")
    }, receiveValue: { value in
        print("     debounce receiveValue: \(value)")
    }).store(in: &subscriptions)
    
    // 模拟检索框 输入值。
    let input : [(Double ,String)] = [
        (0.0, "y"),
        (0.1, "yo"),
        (0.2, "yor"),
        (0.3, "your"),
        (2.6, "your "),// 表示 停顿1秒后，产生debounce 发送
        (2.8, "your b"),
        (3.0, "your bo"),
        (3.4, "your boy"),// 表示 停顿1秒后，产生debounce 发送
    ]
 
    subject.feed(with: input)
}
 
