// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

enum TimeoutError : Error {
    case timeout
}

var subscriptions = Set<AnyCancellable>()

testSample(label: "05_01_timeout"){
    // Output：Void表示 没有发送的数据，只传递事件通知。
    let subject = PassthroughSubject<Void, TimeoutError>()
    // 这里的timeout仅仅表示 ，subject.send() 没有发送数据的情况。间隔时间2s后，再发送，不发生 error。
    let timeout = subject.timeout(.seconds(2), scheduler: DispatchQueue.main, customError: { .timeout})
    
    subject.sink(receiveCompletion: { completion in
                print("subject completion:\(completion)")
            }, receiveValue: { value in
                print(" \(Date().timeIntervalSince1970)")
                print("subject receiveValue: \(value)")
            }).store(in: &subscriptions)
    
    timeout.sink(receiveCompletion: { completion in
        print("     timeout completion:\(completion)")
    }, receiveValue: { value in
        print("     timeout receiveValue: \(value)")
    }).store(in: &subscriptions)
    
//    subject.send()
    
    Thread.sleep(forTimeInterval: 5.0)
     subject.send()
//    Thread.sleep(forTimeInterval: 7.0)
    subject.send(completion: .finished)
}
 
