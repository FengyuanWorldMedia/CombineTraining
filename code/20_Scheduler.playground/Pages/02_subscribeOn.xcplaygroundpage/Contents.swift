// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine


let globalQueue = DispatchQueue.global()

print("Current thread \(Thread.current)")
let k = ["a", "b", "c", "d", "e"].publisher
    .subscribe(on: globalQueue)
    .receive(on: DispatchQueue.main)
    .map({ (param) -> String in
        print(" param _yy on thread \(Thread.current)")
        return param + "_yy"
    })
    .receive(on: globalQueue)
    .map({ (param) -> String in
        print(" param _xx on thread \(Thread.current)")
        return param + "_xx"
    })
    .receive(on: DispatchQueue.main)
    .sink(receiveValue: {
        print(" got \($0) on thread \(Thread.current)")
  })


Just(1)
   .map { _ in print(Thread.isMainThread) }
   .subscribe(on: DispatchQueue.global()) // Position of subscribe(on:) has changed
   .sink { print(Thread.isMainThread) }
