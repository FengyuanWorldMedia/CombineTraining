// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

//: [Previous](@previous)

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("-----您正在演示:\(label)-----")
    testBlock()
    print("-----演示:\(label)结束-----")
}

enum MyErrors :Error {
    case wrongVlue
}

testSample(label: "CurrentValueSubject sample1" ) {
    let myPubliser = CurrentValueSubject<String,MyErrors>("100")

    let mySubscriber = myPubliser.filter({
        return $0.count < 5
    }).sink(receiveCompletion: { completion in
        if completion == .failure(MyErrors.wrongVlue) {
            print("myScriber1 MyErrors.wrongVlue")
        } else {
            print(completion)
        }
    }, receiveValue: { value in
        print("myScriber1 Value:\(value)")
    })
    
    let myScriber = Subscribers.Sink<String, MyErrors> (receiveCompletion: { completion in
        if completion == .finished {
            print("myScriber2 Finished")
        } else {
            print("myScriber2 Failure")
        }
    }, receiveValue: { value in
        print("myScriber2 receiveValue: \(value)")
    })
    
    /// 产生订阅关系
    myPubliser.receive(subscriber: myScriber)
    
    /// 发送数据
    myPubliser.send("h")
    myPubliser.send("he")
    myPubliser.send("hel")
    myPubliser.send("hell")
    myPubliser.send("hello")
    myPubliser.send("hello,world.")

    // 发送失败数据
    myPubliser.send(completion: .failure(.wrongVlue))
    // 即使发送，订阅者也接收不到
    myPubliser.send("ni") // 结束后（错误结束或者正常结束），将不再发布。
}

testSample(label: "CurrentValueSubject sample2" ) {
    
    let subject1: CurrentValueSubject<Int, MyErrors> = .init(55)
    let subject2: CurrentValueSubject<Int, MyErrors> = .init(100)
    
    // subject1 -> subject2; 箭头指的是 数据流
    let cancelable = subject1.subscribe(subject2)
 
    let myScriber = Subscribers.Sink<Int, MyErrors> (receiveCompletion: { completion in
        if completion == .finished {
            print("myScriber2 Finished")
        } else {
            print("myScriber2 Failure")
        }
    }, receiveValue: { value in
        print("myScriber2 receiveValue: \(value)")
    })
    
    // subject1 -> subject2 -> myScriber
    subject2.receive(subscriber: myScriber)
    
    subject1.send(1)
    subject1.send(2)
    subject2.send(66)
    //myPubliser.send(completion: .finished)
    subject1.send(completion: .failure(.wrongVlue))
    
    subject1.send(11)
    subject2.send(77)
   // subject1.send(3) // 结束后（错误结束或者正常结束），将不再发布。
    
//    myScriber2 receiveValue: 55
//    myScriber2 receiveValue: 1
//    myScriber2 receiveValue: 2
//    myScriber2 receiveValue: 66
//    myScriber2 Failure
}

testSample(label: "PassthroughSubject sample3" ) {
    
    let subject1: PassthroughSubject<Int, MyErrors> = PassthroughSubject()
    let subject2: PassthroughSubject<Int, MyErrors> = PassthroughSubject()
    
    // subject1 -> subject2
    let cancelable = subject1.subscribe(subject2)
 
    let myScriber = Subscribers.Sink<Int, MyErrors> (receiveCompletion: { completion in
        if completion == .finished {
            print("myScriber2 Finished")
        } else {
            print("myScriber2 Failure")
        }
    }, receiveValue: { value in
        print("myScriber2 receiveValue: \(value)")
    })
    
    // subject1 -> subject2 -> myScriber
    subject2.receive(subscriber: myScriber)
    
    subject1.send(1)
    subject1.send(2)
    subject2.send(66)
    //myPubliser.send(completion: .finished)
    subject1.send(completion: .failure(.wrongVlue))
    
    subject1.send(11)
    subject2.send(77)
    
   // subject1.send(3) // 结束后（错误结束或者正常结束），将不再发布。
    
//    myScriber2 receiveValue: 1
//    myScriber2 receiveValue: 2
//    myScriber2 receiveValue: 66
//    myScriber2 Failure
}
