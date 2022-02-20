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
    userQueue.sync {
        task1()
    } 
    userQueue.sync {
        task2()
    }
}
/// 这个实例中 ，DispatchQueue#sync 为同步执行，也就是 task1 在完成之后 再进行 task2 的执行。
