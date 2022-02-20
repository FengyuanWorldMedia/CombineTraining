// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

var subscriptions = Set<AnyCancellable>()

/// map, 对每一个数据进行处理
testSample(label: "02_map"){
    let arrPublisher = [100,200,300,20,14].publisher
    arrPublisher
        //.print("arrPublisher")
        .map({ val in
            return "\(val)hello" /// 把每一个数据从 int转成了String。
        })
        .sink(receiveCompletion: { completion in
            print("02_map completion:\(completion)")
        }, receiveValue: { value in
            print("02_map value : \(value)")
        }).store(in: &subscriptions)
}

/// try, 对每一个数据进行处理
testSample(label: "02_trymap"){
    
    enum MyError : Error {
        case wrongData
    }
    
    let arrPublisher = [100,200,300,20,9999].publisher
    arrPublisher
        //.print("arrPublisher")
        .tryMap({ (val) -> String in
            if val == 300 {
                throw MyError.wrongData
            }
            return "\(val)hello"
        })
        .sink(receiveCompletion: { completion in
            print("02_trymap completion:\(completion)")
        }, receiveValue: { value in
            print("02_trymap value : \(value)")
        }).store(in: &subscriptions)
}

/// map, 一个keyPath
testSample(label: "02_map01"){
    
    struct PersonInfo {
        var name : String
        var age : Int
        var nickName : String?
    }
    let sourcePublisher = PassthroughSubject<PersonInfo, Never>()
    sourcePublisher
        //.print("arrPublisher")
        .map(\.name)
        .sink(receiveCompletion: { completion in
            print("02_map01 completion:\(completion)")
        }, receiveValue: { value in  /// 获取 PersonInfo.name
            print("02_map01 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(PersonInfo(name: "liu", age: 15))
    sourcePublisher.send(PersonInfo(name: "zhang", age: 15))
}

/// map, 2个keyPath
testSample(label: "02_map02"){
    
    struct PersonInfo {
        var name : String
        var age : Int
        var nickName : String?
    }
    let sourcePublisher = PassthroughSubject<PersonInfo, Never>()
    sourcePublisher
        //.print("arrPublisher")
        .map(\.name, \.age)
        .sink(receiveCompletion: { completion in
            print("02_map02 completion:\(completion)")
        }, receiveValue: { value, age in  /// 获取 PersonInfo.name和PersonInfo.age
            print("02_map02 name : \(value), age :\(age)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(PersonInfo(name: "liu", age: 15))
    sourcePublisher.send(PersonInfo(name: "zhang", age: 15))
}

/// map, 3个keyPath
testSample(label: "02_map02"){
    
    struct PersionInfo {
        var name : String
        var age : Int
        var nickName : String?
    }
    let sourcePublisher = PassthroughSubject<PersionInfo, Never>()
    sourcePublisher
       // .print("arrPublisher")
        .map(\.name, \.age, \.nickName)
        .sink(receiveCompletion: { completion in
            print("02_map02 completion:\(completion)")
        }, receiveValue: { name, age, nickName in  /// 获取 PersionInfo.name
            print("02_map02 name : \(name), age :\(age) , nickName :\(nickName!)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(PersionInfo(name: "liu", age: 15, nickName: "niuniu"))
    sourcePublisher.send(PersionInfo(name: "zhang", age: 15, nickName: "handsome"))
}
