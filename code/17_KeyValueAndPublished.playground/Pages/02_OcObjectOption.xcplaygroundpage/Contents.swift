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
 
class OcObject : NSObject {
    @objc dynamic var intValue: Int = 0
}
 
testSample(label: "02_OcObjectOption"){
    
    let object = OcObject()
    let ocPublisher = object.publisher(for: \.intValue, options: [.initial]) /// 监视OcObject 的intValue 变化。 initial 表示object 初始值 也会被发送。
    ocPublisher
        .sink(receiveCompletion: { completion in
            print("02_OcObjectOption completion:\(completion)")
        }, receiveValue: { value in
            print("02_OcObjectOption value : \(value)")
        }).store(in: &subscriptions)
    
    object.intValue = 1
    
}

testSample(label: "02_OcObjectOption1") {
    
    let object = OcObject()
    let ocPublisher = object.publisher(for: \.intValue, options: [.initial, .prior]) /// 监视OcObject 的intValue 变化。 initial 表示object 初始值 也会被发送，prior 表示 变化前后的数据都被接受。
    ocPublisher
        .sink(receiveCompletion: { completion in
            print("02_OcObjectOption1 completion:\(completion)")
        }, receiveValue: { value in
            print("02_OcObjectOption1 value : \(value)")
        }).store(in: &subscriptions)
    
    object.intValue = 3
    object.intValue = 5
}
