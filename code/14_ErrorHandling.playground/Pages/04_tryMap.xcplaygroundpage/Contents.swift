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
    }
    
    let sourcePublisher = PassthroughSubject<Int, MyErrors>()
    
    sourcePublisher
       // .print("debugInfo")
        .tryMap({ (val) -> Int? in   /// tryMap 中的try表示，有可能会产生 错误。
            if val == 2 {
                throw MyErrors.wrongValue
            }
            return val
        }).sink(receiveCompletion: { completion in
            print("04_tryMap completion:\(completion)")
        }, receiveValue: { value in
            print("04_tryMap value : \(value ?? 999)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    
    sourcePublisher.send(completion: .failure(.endValue)) /// 发布错误
}

 
