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

testSample(label: "06_01_measuretime"){
    
    let subject = PassthroughSubject<String, TimeoutError>()
    
    let measure = subject.measureInterval(using: DispatchQueue.main)
    
    subject.sink(receiveCompletion: { completion in
                print("subject completion:\(completion)")
            }, receiveValue: { value in
                print("subject receiveValue: \(value)")
            }).store(in: &subscriptions)
   
    measure.sink(receiveCompletion: { completion in
        print("     measure completion:\(completion)")
    }, receiveValue: { date in
        print("     measure receiveValue: \(date)")
    }).store(in: &subscriptions)
    
    subject.send("1")
    Thread.sleep(forTimeInterval: 0.2)
    subject.send("12")
    Thread.sleep(forTimeInterval: 0.3)
    subject.send("123")
    Thread.sleep(forTimeInterval: 0.4)
    subject.send("1234")
    subject.send(completion: .finished)
}
 
