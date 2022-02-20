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
// 测试 share
testSample(label: "03_02_shareOutput"){
    
    let pub = (1...3).publisher
        .delay(for: 1, scheduler: DispatchQueue.main)
        .map( { _ in return Int.random(in: 0...100) } )
        // .print("Random")
        .share() // Shares the output of an upstream publisher with multiple subscribers.
    
        pub.sink { print ("Stream 1 received: \($0)")}
            .store(in: &subscriptions)
        
        pub.sink { print ("Stream 2 received: \($0)")}
            .store(in: &subscriptions)
}
