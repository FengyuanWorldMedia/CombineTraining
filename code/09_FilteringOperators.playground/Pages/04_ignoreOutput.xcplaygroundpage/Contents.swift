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
 
/// ignoreOutput, 忽略所有的发布数据，但是 结束会接收。
testSample(label: "04_ignoreOutput"){
    let numbers = (0...5).publisher 
    let cancellable = numbers
            .ignoreOutput()
            .sink(receiveCompletion: { completion in
                print("04_ignoreOutput completion:\(completion)")
            }, receiveValue: { value in
                print("04_ignoreOutput value : \(value)")
            })
            .store(in: &subscriptions)
}
