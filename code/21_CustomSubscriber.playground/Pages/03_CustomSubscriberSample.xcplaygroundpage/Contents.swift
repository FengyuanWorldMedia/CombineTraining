// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.
import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("-----您正在演示:\(label)-----")
    testBlock()
    print("-----演示:\(label)结束-----")
}

///  本示例讲解 ： 动态调整Subscribers.Demand; 类class实现 Subscriber 协议
///  找出和 指定字符串相等的 字符串。
///
testSample(label: "Subscriber sample3" ) {
    
    final class SearchSubscriber : Subscriber {
        
        private var searchString : String
        
        init(searchString : String) {
            self.searchString = searchString
        }
        
        // 1.设定接受的数据类型
        typealias Input = String
        typealias Failure = Never
        
        // 2.初始的时候，设定接受的 数据次数
        func receive(subscription: Subscription) {
            /// 初始化的时候，接受一个字符串
             subscription.request(.max(1))
        }
        
        // 3.在每次接受数据后，重新设定希望 接受的 数据次数，总次数是 request（Subscription）方法中的设定值和receive（Output）中的总和。
        func receive(_ input: String) -> Subscribers.Demand {
            print("receive value : \(input)")
            if input == self.searchString {
                return .max(0)
            } else {
                return .max(1)
            }
        }
        
        // 4.接收到 结束
        func receive(completion: Subscribers.Completion<Never>) {
            print("completion : \(completion)")
        }
    }
    
    let subscriber = SearchSubscriber(searchString: "丰源天下")
    
    let publisher = PassthroughSubject<String, Never>()
    publisher.subscribe(subscriber)
    publisher.send("苏州丰源天下")
    publisher.send("丰源天下传媒")
    publisher.send("丰源天下") /// 找到，后续不再接受。
    publisher.send("苏州丰源天下传媒")
    publisher.send(completion: .finished)
}


///  本示例讲解 ： 动态调整Subscribers.Demand; 结构体struct实现 Subscriber 协议
///  找出和 指定字符串相等的 字符串。
///
testSample(label: "Subscriber sample31" ) {
    
    let publisher = PassthroughSubject<String, Never>()
    
    struct SearchSubscriber: Subscriber {
       
        public var combineIdentifier: CombineIdentifier { /// 注意这里的 CustomCombineIdentifierConvertible 协议实现。
            return CombineIdentifier()
        }
        
        private var searchString : String
        
        init(searchString : String) {
            self.searchString = searchString
        }
        
        // 1.设定接受的数据类型
        typealias Input = String
        typealias Failure = Never
        
        // 2.初始的时候，设定接受的 数据次数
        func receive(subscription: Subscription) {
            /// 初始化的时候，接受一个字符串
             subscription.request(.max(1))
        }
        
        // 3.在每次接受数据后，重新设定希望 接受的 数据次数，总次数是 request（Subscription）方法中的设定值和receive（Output）中的总和。
        func receive(_ input: String) -> Subscribers.Demand {
            print("receive value : \(input)")
            if input == self.searchString {
                return .max(0)
            } else {
                return .max(1)
            }
        }
        
        // 4.接收到 结束
        func receive(completion: Subscribers.Completion<Never>) {
            print("completion : \(completion)")
        }
    }
    
    let subscriber = SearchSubscriber(searchString: "丰源天下")
    
    publisher.subscribe(subscriber)
    publisher.send("苏州丰源天下")
    publisher.send("丰源天下传媒")
    publisher.send("丰源天下") /// 找到，后续不再接受。
    publisher.send("苏州丰源天下传媒")
    publisher.send(completion: .finished)
}


///  本示例讲解 ： 动态调整Subscribers.Demand; 结构体struct实现 Subscriber 协议
///  找出和 指定字符串相等的 字符串。
///
testSample(label: "Subscriber sample32" ) {
    
    let publisher = PassthroughSubject<String, Never>()
    
    struct SearchSubscriber : Subscriber {
        
        class SearchSubscriberID {
            let uuid = UUID()
        }
        
        let id = SearchSubscriberID()
        
        public var combineIdentifier: CombineIdentifier { /// 注意这里的 CustomCombineIdentifierConvertible 协议实现。
            return CombineIdentifier(self.id)
        }
        
        private var searchString : String
        
        init(searchString : String) {
            self.searchString = searchString
        }
        
        // 1.设定接受的数据类型
        typealias Input = String
        typealias Failure = Never
        
        // 2.初始的时候，设定接受的 数据次数
        func receive(subscription: Subscription) {
            /// 初始化的时候，接受一个字符串
             subscription.request(.max(1))
        }
        
        // 3.在每次接受数据后，重新设定希望 接受的 数据次数，总次数是 request（Subscription）方法中的设定值和receive（Output）中的总和。
        func receive(_ input: String) -> Subscribers.Demand {
            print("receive value : \(input)")
            if input == self.searchString {
                return .max(0)
            } else {
                return .max(1)
            }
        }
        
        // 4.接收到 结束
        func receive(completion: Subscribers.Completion<Never>) {
            print("completion : \(completion)")
        }
    }
    
    let subscriber = SearchSubscriber(searchString: "丰源天下")
    
    publisher.subscribe(subscriber)
    publisher.send("苏州丰源天下")
    publisher.send("丰源天下传媒")
    publisher.send("丰源天下") /// 找到，后续不再接受。
    publisher.send("苏州丰源天下传媒")
    publisher.send(completion: .finished)
}
