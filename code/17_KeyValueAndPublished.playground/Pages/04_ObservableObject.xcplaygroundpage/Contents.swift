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

class MyModel2: ObservableObject {
      @Published var id: Int = 0
}

testSample(label: "04_ObservableObject") {
      let model2 = MyModel2()
      Just(100)
        .assign(to: &model2.$id)
      print(model2.id)
}
 
testSample(label: "04_ObservableObject1") {
    let model2 = MyModel2()
    model2.$id.sink() {
         print("04_ObservableObject1: \($0)")
    }
    model2.objectWillChange.sink(receiveValue: { /// objectWillChange 是编译器自动生成的。
        print("model2 property changed")
    })
    
    model2.id = 100
    model2.id = 200
    model2.id = 200
}
