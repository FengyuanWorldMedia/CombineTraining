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
 
public struct Chatter {
    public let name: String
    public let message : CurrentValueSubject<String , Never>
    
    public init(name : String , message: String) {
        self.name = name
        self.message = CurrentValueSubject(message)
    }
}

testSample(label: "03_flatMap") {
    let personA = Chatter(name: "personA" , message : "hi personA")
    let personB = Chatter(name: "personB" , message : "hi personB")
    let chat =  CurrentValueSubject<Chatter , Never>(personA)
    chat
        //.print("chat")
        .sink(receiveCompletion: { completion in
            print("03_flatMap completion:\(completion)")
        }, receiveValue: { value in
            print("03_flatMap value : \(value)")
        }).store(in: &subscriptions)

    /// 以下的赋值将会 出发 receiveValue
    personA.message.value = "hi personA 2"
    chat.value = personA
}


/// flatMap 的意义在于，为chat 增加上流 Publisher。
/// 每次 chat.value 赋值的时候增加，或者 chat.send(ChatterXX) 的时候增加。
testSample(label: "03_flatMap01") {
    
    let personA = Chatter(name: "personA" , message : "personA: hi , everybody.")
    let personB = Chatter(name: "personB" , message : "personB: hi , everybody.")
    
    let chat =  CurrentValueSubject<Chatter , Never>(personA)
    
    chat.flatMap { output ->  CurrentValueSubject<String , Never> in /// 这个转换，会把 CurrentValueSubject<Chatter , Never>(personA) 变为 personA.message , 其类型为 CurrentValueSubject(String)
          return output.message ////  每次 chat.value赋值的时候，这个将会增加一个publisher。在初始的时候 ，chat.value 为 personA。 这里的 chat.value 代表着 聊天频道。
        }  /// Publishers.FlatMap
        .sink(receiveCompletion: { completion in
            print("03_flatMap01 completion:\(completion)")
        }, receiveValue: { value in
            print("03_flatMap01 value : \(value)")
        }).store(in: &subscriptions)
    /// 以下的赋值将会 出发 receiveValue
    personA.message.value = "hi personB, are you OK?"
    chat.value = personB
    personB.message.value = "hi personA . Fine, thank you"
}


/// flatMap： maxPublishers 在于控制，chat增加上流 Publisher 的数量。
testSample(label: "03_flatMap03") {
    
    let personA = Chatter(name: "personA" , message : "hi personA")
    let personB = Chatter(name: "personB" , message : "hi personB")
    let personC = Chatter(name: "personB" , message : "hi personB")
    
    let chat =  CurrentValueSubject<Chatter , Never>(personA)
    chat
        .flatMap(maxPublishers : .max(2)) {
           $0.message
        }
        .sink(receiveCompletion: { completion in
            print("03_flatMap03 completion:\(completion)")
        }, receiveValue: { value in
            print("03_flatMap03 value : \(value)")
        }).store(in: &subscriptions)
    /// 以下的赋值将会 出发 receiveValue
    personA.message.value = "hi personA 2"
    personB.message.value = "hi personB 2"
    chat.value = personB
    personA.message.value = "hi personA 3"
    personB.message.value = "hi personB 3"
    
    chat.value = personC
    personC.message.value = "personC: hi personC 2"
    
}
 


























testSample(label: "zipCodePublisher"){
    struct ZipCode {
        public let code: String
    }
    var zipCodePublisher = PassthroughSubject<ZipCode, URLError>()

    zipCodePublisher.flatMap { (zipCode) -> URLSession.DataTaskPublisher in
        let url = URL(string: "https://api.zippopotam.us/us/\(zipCode.code)/")!
        return URLSession.shared.dataTaskPublisher(for: url)
    }.sink( receiveCompletion: { completion in
            print(completion)
        },
        receiveValue: { value in
            print("ZipCodeInformation : \(value)")
        }
     ).store(in: &subscriptions)

    zipCodePublisher.send(ZipCode(code: "90210"))
    zipCodePublisher.send(ZipCode(code: "90220"))
    zipCodePublisher.send(ZipCode(code: "90230"))
}
