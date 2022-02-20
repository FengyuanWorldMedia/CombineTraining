// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

/// 这个示例给出了 并行操作的，串行方法。在 执行子task 的时候 可以同步，子task都完成后 继续合并处理。
func semaphoreTest() {

    let workerQueue = DispatchQueue.global()
 
    /// 初始值代表，task同时执行的上限数, 如果 一个 task 中执行semaphore.signal() 后，另一个才能开始，需要等待 。
    /// 初始值 在业务抽象上，代表着 资源的抢占最大数。（也就是 同时执行的task个数）。
    ///
    //    * Passing zero for the value is useful for when two threads need to reconcile
    //    * the completion of a particular event. Passing a value greater than zero is
    //    * useful for managing a finite pool of resources, where the pool size is equal
    //    * to the value.
    
    let semaphore = DispatchSemaphore(value: 0)
    
    print("semaphoreTest 1")
    workerQueue.async {
        sleep(3)
        print("semaphoreTest 2")
        semaphore.signal()
    }
    semaphore.wait() /// 阻塞 直到  semaphore.signal() 执行
    
    workerQueue.async {
        sleep(5)
        print("semaphoreTest 3")
        semaphore.signal()
    }
 
    semaphore.wait() /// 阻塞 直到  semaphore.signal() 执行。
    print("semaphoreTest end")
}

semaphoreTest()

