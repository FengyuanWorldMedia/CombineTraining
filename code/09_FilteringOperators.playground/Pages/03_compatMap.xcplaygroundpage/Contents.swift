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
 
/// compactMap, 如果返回的为nil 的话，可以直接忽略掉。
testSample(label: "03_compatMap"){
    let numbers = (0...5).publisher
    let romanNumeralDict: [Int : String] = [1: "I", 2: "II", 3: "III", 5: "V"]
    let cancellable = numbers
            .compactMap { romanNumeralDict[$0] }
            .sink { print("\($0)") }
            .store(in: &subscriptions)
}

/// compactMap, 如果返回的为nil 的话，可以直接忽略掉。
testSample(label: "03_compatMap"){
    let numbers = ["1","2","3", "abc","4"].publisher
    let cancellable = numbers
        .compactMap({
            Float($0)
        })
        .sink(receiveCompletion: { completion in
            print("     01_removeDuplicates02 completion:\(completion)")
        }, receiveValue: { value in
            print("     01_removeDuplicates02 value : \(value)")
        })
        .store(in: &subscriptions)
}
