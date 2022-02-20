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

/// setFailureType
testSample(label: "04_tryMap"){
    
    enum MyErrors: Error {
        case wrongValue
        case endValue
        case defalutError1
        case defalutError2
        case defalutError
    }
    
    let sourcePublisher = PassthroughSubject<Int, MyErrors>()
    
    sourcePublisher
        .print("debugInfo")
        .tryMap({ (val) -> Int? in   /// tryMap 中的try表示，有可能会产生 错误。
            if val == 2 {
                throw MyErrors.wrongValue
            }
            return val
        })
        .retry(2)
        /// 可以从 Log看出 打印两次 debugInfo: receive subscription: (PassthroughSubject)， 表示订阅了两次，而错误也将被忽略。
                /// 当上游的Publisher 发布的数据时动态的或者 上游的 Publisher 本身是动态的话，产生的数据 具有 动态的情况，就可以使用retry 去获取不产生error 的数据，忽略有error的情况。
        .sink(receiveCompletion: { completion in
            print("04_tryMap completion:\(completion)") /// 输出 MyErrors.defalutError1
        }, receiveValue: { value in
            print("04_tryMap value : \(value)")
        }).store(in: &subscriptions)
     
    sourcePublisher.send(2)
     
}

 
