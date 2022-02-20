// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

//: [Previous](@previous)

import Foundation 

/// 这是一个演示代码的区域，目的是为了不让变量重名
/// - Parameters:
///   - label: 演示代码描述
///   - testBlock: 演示代码
public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

//: [Next](@next)
