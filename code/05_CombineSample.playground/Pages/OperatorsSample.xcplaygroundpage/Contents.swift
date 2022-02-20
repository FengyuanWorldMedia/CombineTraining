// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

////https://developer.apple.com/documentation/combine/publishers
//Publishers.Map
//Publishers.Filter
//Publishers.Debounce
//Publishers.RemoveDuplicates
//Publishers.ReceiveOn
//Publishers.TryMap
//Publishers.FlatMap
//Publishers.Catch
//Publishers.CombineLatest
//Publishers.Merge
//Publishers.Zip
//Publishers.Decode
//Publishers.Autoconnect

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

testSample(label: "Operator map 1" ) {
    let myPubliser2 = Just("55")

    let tansValuePubliser = Publishers.Map<Just<String>,Int>(upstream: myPubliser2, transform: {
        value in
        return Int(value) ?? 0
    })

    let myScriber2 = Subscribers.Sink<Int,Never> (receiveCompletion: { completion in
        if completion == .finished {
            print("Finished")
        } else {
            print("Failure")
        }
    }, receiveValue: { value in
        print(value)
    })
    
    tansValuePubliser.subscribe(myScriber2)
}

testSample(label: "Operator map 2" ) {
    _ = Just(50).filter({
        value in
        return value < 100
    }).sink(receiveCompletion: { completion in
        if completion == .finished {
            print("Finished")
        } else {
            print("Failure")
        }
    }, receiveValue: { value in
        print(value)
    })
}
 
