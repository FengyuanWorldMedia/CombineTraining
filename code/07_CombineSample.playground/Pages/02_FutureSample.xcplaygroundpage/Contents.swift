// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("-----您正在演示:\(label)-----")
    testBlock()
    print("-----演示:\(label)结束-----")
}

testSample(label: "FutureSample sample1" ) {
    
    func futureIncrement( integer : Int ) -> Future<Int , Never> {
        return Future { promise in
            /// 复杂计算
            sleep(3)
            promise(.success(integer + 1))
        }
    }
    
    let future = futureIncrement(integer: 1 )
    
    future.sink(receiveCompletion: { result in
        print("result : \(result)")
    }, receiveValue: { value in
        print("value : \(value)")
    })
}
                                      
/// 理解 promise 的异步执行返回，订阅的时间点可以在promise执行前后 。 没有时间前后限制。
/// 注意点：attemptToFulfill（promise） 和  promise 的执行线程要一致，否则 订阅者 又可能接受不到数据。
testSample(label: "FutureSample sample2" ) {
    
    
    func futureIncrement( integer : Int , afterDelay delay : TimeInterval) -> Future<Int , Never> {
        /// 1.
        return Future { promise in
//            DispatchQueue.global().asyncAfter(deadline: .now() + delay , execute: {
//                print("asyncAfter start")
//                promise(.success(integer + 1))
//                print("asyncAfter end")
//            })
            sleep(3)
            promise(.success(integer + 1))
        }
    }

    let future = futureIncrement(integer: 1, afterDelay: 3)
    var subscriptions = Set<AnyCancellable>()
  
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: {
        future.sink(receiveCompletion: { result in
            print("result : \(result)")
        }, receiveValue: { value in
            print("value : \(value)")
        }).store(in: &subscriptions)
    })
    
    print("subscriptions count:\(subscriptions.count)")
    
}
//


//: [Next](@next)
