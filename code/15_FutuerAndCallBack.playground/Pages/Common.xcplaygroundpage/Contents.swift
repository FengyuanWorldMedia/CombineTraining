// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

//: [Previous](@previous)

import Foundation 

/// 这是一个演示代码的区域，目的是为了不让变量重名
/// - Parameters:
///   - label: 演示代码描述
///   - testBlock: 演示代码
//public func testSample(label: String , testBlock: () -> Void) {
//    print("您正在演示 非逃逸闭包:\(label)")
//    testBlock()
//    print("演示:\(label)结束")
//}


//: [Next](@next)

class HTMLElement {

    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        [unowned self] in
//        [self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }

}
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())

paragraph = nil
