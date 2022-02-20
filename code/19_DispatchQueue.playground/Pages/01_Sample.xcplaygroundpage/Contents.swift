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

let userQueue = DispatchQueue.global(qos: .userInitiated)
print("=== Starting userInitated global queue ===")
duration {
    userQueue.async {
        task1()
    }
    userQueue.async {
        task2()
    }
}

/// 从这个例子可以看出，task1 和task2 顺序执行，但是 由于 task1 执行的时间比较长（sleep(1)）, 所以 task2 先结束。
/// 又 因为 是异步执行，这是 的 duration中打印的时间，并不是 task 执行的时间，而是 受理完成的时间。
/// 这是注意的是 qos 的优先级设定和global 并发线程池的使用。
///
