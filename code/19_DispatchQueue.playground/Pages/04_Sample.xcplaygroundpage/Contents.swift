// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

func add(_ input: (Int, Int)) -> Int {
  sleep(1)
  return input.0 + input.1
}

let workerQueue = DispatchQueue(label: "fytx.com.concurrent.group", attributes: .concurrent)
let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]

let addGroup = DispatchGroup()

for pair in numberArray {
    workerQueue.async(group: addGroup) {
        let result = add(pair)
        print("workerQueue  :\(Thread.current)")
        print("Result = \(result)")
    }
}

// 阻塞，等带Group内的全部task执行完毕。
addGroup.wait(timeout: DispatchTime.distantFuture)

/// 当前 线程信息
print("Main :\(Thread.current)")

let defaultQueue = DispatchQueue.global()

// 全部task执行完后， 在 DispatchQueue.global执行 闭包。
addGroup.notify(queue: defaultQueue) {
  print("global :\(Thread.current)")
  print("Completed!")
}
