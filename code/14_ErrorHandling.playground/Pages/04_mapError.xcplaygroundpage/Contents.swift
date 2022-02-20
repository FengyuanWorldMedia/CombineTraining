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
    
    enum YourErrors: Error {
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
        .mapError({ err -> YourErrors in
            switch (err) {
                case MyErrors.wrongValue : return YourErrors.defalutError1  /// 最终会在这里 转错误信息
                case MyErrors.endValue : return YourErrors.defalutError2
            default:
                YourErrors.defalutError
            }
            return YourErrors.defalutError
        })
        .sink(receiveCompletion: { completion in
            print("04_tryMap completion:\(completion)") /// 输出 MyErrors.defalutError1
        }, receiveValue: { value in
            print("04_tryMap value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    
    sourcePublisher.send(completion: .failure(.endValue)) /// 发布错误
}

 
