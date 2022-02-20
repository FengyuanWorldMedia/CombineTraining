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

testSample(label: "02_multicast") {
    /// 使用multicast Operator不但可以共享 Publisher，同时也能控制 订阅的时间点（以方便让所有的订阅起效。）
    /// 通过 multicast 可以 让DataTaskPublisher 转为 multicast publisher ，其类型和 PassthroughSubject 一致。
    /// DataTaskPublisher 的数据定义，要和 PassthroughSubject 的定义一致。
            //    /// The kind of values published by this publisher.
            //    public typealias Output = (data: Data, response: URLResponse)
            //    /// The kind of errors this publisher might publish.
            //    /// Use `Never` if this `Publisher` does not publish errors.
            //    public typealias Failure = URLError

    let multicasted = URLSession.shared
        .dataTaskPublisher(for: URL(string: "https://www.google.com")!)
        .map(\.data)
        .print("shared")
        .multicast { PassthroughSubject<Data, URLError>() } /// A subject to deliver elements to downstream subscribers.  multicast publisher is a ``ConnectablePublisher``

    print("subscribe 1回目")
    multicasted
        .sink( receiveCompletion: { _ in },
               receiveValue: { print("subscription1 receiveValue: '\($0)'") })
        .store(in: &subscriptions)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        print("subscribe 2回目")
        multicasted
            .sink( receiveCompletion: { _ in },
                   receiveValue: { print("subscription2 receiveValue: '\($0)'") })
            .store(in: &subscriptions)
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        print("connect")
        multicasted
            .connect()
            .store(in: &subscriptions)
    }
}


testSample(label: "02_multicast2"){
    
     let pub = ["First", "Second", "Third"].publisher
         .map( { return ($0, Int.random(in: 0...100)) } )
         .print("Random")
         .multicast(subject: PassthroughSubject<(String, Int), Never>()) /// A subject to deliver elements to downstream subscribers.  multicast publisher is a ``ConnectablePublisher``

     pub
         .sink { print ("Stream 1 received: \($0)")}
         .store(in: &subscriptions)
    
      pub
         .sink { print ("Stream 2 received: \($0)")}
         .store(in: &subscriptions)
    
     pub.connect()
}
