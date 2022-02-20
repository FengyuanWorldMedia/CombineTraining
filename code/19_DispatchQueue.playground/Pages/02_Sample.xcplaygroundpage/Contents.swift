// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

// 执行时间
func duration(_ block: () -> ()) {
  let startTime = Date()
  block()
  let endTime = Date().timeIntervalSince(startTime)
  print(endTime)
}

func task1() {
  print("Task 1 started")
  sleep(1)
  print("Task 1 finished")
}

func task2() {
  print("Task 2 started")
  print("Task 2 finished")
}

let mySerialQueue = DispatchQueue(label: "fytx.com")

print("\n=== Starting mySerialQueue ===")
duration {
    mySerialQueue.async {
        task1()
    }
    mySerialQueue.async {
        task2()
    }
}

/// 这里的 DispatchQueue(label: "fytx.com") 是一个自定义的 一个DispatchQueue，没有指定是否是并发，如果没有的制定的话，就是 顺序执行。
///  也就是说: task2 的执行在 task1 完成之后进行。
///
//=== Starting mySerialQueue ===
//Task 1 started
//0.0016629695892333984
//Task 1 finished
//Task 2 started
//Task 2 finished

let workerQueue = DispatchQueue(label: "fytx.com.concurrent", attributes: .concurrent)

print("\n=== Starting workerQueue ===")
duration {
    workerQueue.async {
        task1()
    }
    workerQueue.async {
        task2()
    }
}
/// 指定自定义的DispatchQueue 为并发的情况，task1 和task2 顺序执行，但是 由于 task1 执行的时间比较长（sleep(1)）, 所以 task2 先结束。
//=== Starting workerQueue ===
//Task 1 started
//Task 2 started
//Task 2 finished
//0.0016520023345947266
//Task 1 finished
