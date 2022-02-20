// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

let immediateScheduler = ImmediateScheduler.shared

print("Current thread:  \(Thread.current)")

let aNum = [1,2,3].publisher
    .receive(on: immediateScheduler)
    .sink(receiveValue: {
        print("Received \($0)")
        print("Received thread:  \(Thread.current)")
})

