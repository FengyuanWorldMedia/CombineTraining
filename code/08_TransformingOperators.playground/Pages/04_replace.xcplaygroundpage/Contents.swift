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

/// replaceNil:with
testSample(label: "04_replace") {
    let sourcePublisher = [12, nil , 13].publisher
    sourcePublisher
        .replaceNil(with: 99)
        .sink(receiveCompletion: { completion in
            print("04_replace completion:\(completion)")
        }, receiveValue: { value in  // 注意这里接受的类型为 Optional（Output）
            print("04_replace value : \(value)")
        }).store(in: &subscriptions)
}

/// replaceEmpty:with
testSample(label: "04_replaceEmpty") {
    let sourcePublisher = Empty<Int , Never>() /// 注意这里的定义 Empty。
    sourcePublisher
        .replaceEmpty(with: 99) // 注意这里接受的类型为 Output
        .sink(receiveCompletion: { completion in
            print("04_replaceEmpty completion:\(completion)")
        }, receiveValue: { value in  // 注意这里接受的类型为 Output
            print("04_replaceEmpty value : \(value)")
        }).store(in: &subscriptions)
}

/// replaceEmpty:with
testSample(label: "04_replaceEmpty1") {
    let sourcePublisher = [].publisher
    sourcePublisher
        .replaceEmpty(with: 99) // 注意这里接受的类型为 Output
        .sink(receiveCompletion: { completion in
            print("04_replaceEmpty1 completion:\(completion)")
        }, receiveValue: { value in  // 注意这里接受的类型为 Output
            print("04_replaceEmpty1 value : \(value)")
        }).store(in: &subscriptions)
}
