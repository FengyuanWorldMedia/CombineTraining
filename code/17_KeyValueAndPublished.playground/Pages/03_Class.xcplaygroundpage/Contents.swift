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

class TestObj {
    var name : String = ""
    var age : Int = 0
}
 
testSample(label: "03_Class"){
    
    let testObj = TestObj()
    
    Just(12).sink(receiveValue: {
        print("03_Class value : \($0)")
    })
    
    Just(14)
        .assign(to: \.age, on: testObj) /// ReferenceWritableKeyPath 要求TestObj 为class
   
    print("testClass value : \(testObj.age)")
}
  
