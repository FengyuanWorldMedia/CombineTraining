// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

/// 这是一个演示代码的区域，目的是为了不让变量重名
/// - Parameters:
///   - label: 演示代码描述
///   - testBlock: 演示代码
public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

enum MyError: Error {
    case operationError
}

/// 使用 callback 和 Future分别写出 一个 ，需求为等待计算的任务。
/// 分析两种写法的关联性，以及写法的互相转化。
/// 异步的任务，相同的还有 网络请求（会在接下来的视频中详解。）
///
// ========Closure实现计算====================================================
let errorFlg = true

class AsyncClass {
    func asyncMethod(completionHandler: @escaping (String) -> Void, errorHandler: @escaping (MyError) -> Void) {
        print("async call start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // 异步计算
            if !errorFlg {
                let processName = ProcessInfo.processInfo.processName
                completionHandler(processName)
            } else {
                errorHandler(.operationError)
            }
        }
        print("async call end")
    }
}

testSample(label: "asyncMethod sample") {
    let asyncInstance = AsyncClass()
    asyncInstance.asyncMethod(completionHandler: { processName in
                                print("completionHandler : \(processName)")
                            }, errorHandler: { err in
                                print("errorHandler : \(err)")
                            })
}


// ========Future实现计算====================================================
var scriptions : Set<AnyCancellable> = Set<AnyCancellable>()
/// 注意创建Future task的方法。
func createFutureTask() -> Future<String, MyError> {
    Future<String, MyError> { promise in
        sleep(2)
        if !errorFlg {
            let processName = ProcessInfo.processInfo.processName
            promise(.success(processName))
        } else {
            promise(.failure(.operationError))
        }
    }
}

testSample(label: "Future sample") {
    createFutureTask()
        .subscribe(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Future finished")
            case .failure(let error):
                print("Future \(error)")
        }
        }, receiveValue: { message in
            print("Future message: \(message)")
        }).store(in: &scriptions)
}
