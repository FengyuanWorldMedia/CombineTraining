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
testSample(label: "04_Future"){ // Future的 闭包只执行一次。future执行结束后，两个订阅都可以接受到数据。

    var cnt = 1
    let future = Future<Int,Never> { fullfil in
        cnt = cnt + 1
        print("hello")
        fullfil(.success(cnt))
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        future
            .sink { print ("04_Future received2: \($0)")}
            .store(in: &subscriptions)
    }

    future
        .sink { print ("04_Future received1: \($0)")}
        .store(in: &subscriptions)
}

testSample(label: "04_Future1"){
    
    var cnt = 1
    let future = Future<Int,Never> { fullfil in
        cnt = cnt + 1
        print("hello")
        fullfil(.success(cnt))
    }.share()   /// Future的 闭包只执行一次。 这里的share，使得 一下的两个订阅共享，如果 future执行结束后，第二个订阅者 接收不到数据。
     
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        future
            .sink { print ("04_Future11 received2: \($0)")}
            .store(in: &subscriptions)
    }
    
    future
        .sink { print ("04_Future12 received1: \($0)")}
        .store(in: &subscriptions)
    
}
