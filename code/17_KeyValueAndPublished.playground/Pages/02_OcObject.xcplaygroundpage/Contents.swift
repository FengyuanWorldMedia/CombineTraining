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
// 在Swift代码中，使用@objc修饰后的类型，可以直接供Objective-C调用
class OcObject : NSObject {
    @objc dynamic var intValue: Int = 0
    @objc dynamic var intArr: [Int] = []
}
 
testSample(label: "02_OcObject") {
    
    let object = OcObject()
    let ocPublisher = object.publisher(for: \.intValue) /// 监视OcObject 的intValue 变化。
    ocPublisher
        .sink(receiveCompletion: { completion in
            print("02_OcObject completion:\(completion)")
        }, receiveValue: { value in
            print("02_OcObject value : \(value)")
        }).store(in: &subscriptions)
    
    object.intValue = 1
    object.intValue = 2
    
    let intArrPublisher = object.publisher(for: \.intArr) /// 监视OcObject 的intArr 变化。
    intArrPublisher
        .sink(receiveCompletion: { completion in
            print("02_OcObject2 completion:\(completion)")
        }, receiveValue: { value in  /// 注意receiveValue 类型为[Int]
            print("02_OcObject2 value : \(value)")
        }).store(in: &subscriptions)
    
    object.intArr = [0,1]
    object.intArr = [2,3]
    
}

