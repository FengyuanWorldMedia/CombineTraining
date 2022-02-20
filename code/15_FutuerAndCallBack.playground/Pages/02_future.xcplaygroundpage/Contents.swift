// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

struct MyError: Error {
    var description: String
}

// PublisherとOperator  Future 中的执行为 异步。
let publisher = Future<String, MyError> { promise in
    print("异步 task")
    promise(.success("Hello Combine!"))
    //promise(.failure(MyError(description: "Hello Combine! failure")))
}.map {
    $0 + " This is map operator"
}

let cancellable = publisher.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("finished")
    case .failure(let error):
        print("error \(error.description)")
    }
}, receiveValue: { message in
    print("received message: \(message)")
})





