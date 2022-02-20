// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine
 
public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

/// 对PassthroughSubject进行 两个订阅。
testSample(label: "Subject sample 1" ) {
    
    enum MyError: Error {
        case stringError
    }
    
    final class StringSubscriber : Subscriber {
        typealias Input = String
        typealias Failure = MyError
        
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
        }
        func receive(_ input: String) -> Subscribers.Demand {
            print("receive value : \(input)")
            return .unlimited
        }
        func receive(completion: Subscribers.Completion<MyError>) {
            print("completion : \(completion)")
        }
    }
    
    let subscriber = StringSubscriber()
    
    let subject = PassthroughSubject<String, MyError>()
    
    subject.subscribe(subscriber)
    
    subject.sink(receiveCompletion: { completion in
        /// Subscribers.Completion<Self.Failure>
        switch(completion) {
            case .finished :
                print("receiveCompletion (sink) finished.")
            case .failure(let error) :
            print("receiveCompletion error (sink) : \(error)")
        }
    }, receiveValue: { value in
        print("receiveValue (sink) : \(value)")
    })
    
    subject.send("hello ,world.")
    subject.send("hello ,world2222.")
    // subject.send(completion: .finished)
    subject.send(completion: .failure(.stringError))
}
 
/// 对PassthroughSubject进行 订阅取消。
testSample(label: "Subject sample 2" ) {
    
    enum MyError: Error {
        case stringError
    }
    
    final class StringSubscriber : Subscriber, Cancellable {
        typealias Input = String
        typealias Failure = MyError
        private var subscription: Subscription?
        
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
            self.subscription = subscription
        }
        func receive(_ input: String) -> Subscribers.Demand {
            print("receive value : \(input)")
            return .unlimited
        }
        func receive(completion: Subscribers.Completion<MyError>) {
            print("completion : \(completion)")
        }
        func cancel() {
            self.subscription?.cancel()
        }
    }
    
    let subscriber = StringSubscriber()
    
    let subject = PassthroughSubject<String, MyError>()
    
    subject.subscribe(subscriber)
    
    let subscription =
    subject.sink(receiveCompletion: { completion in
        /// Subscribers.Completion<Self.Failure>
        switch(completion) {
            case .finished :
                print("receiveCompletion (sink) finished.")
            case .failure(let error) :
            print("receiveCompletion error (sink) : \(error)")
        }
    }, receiveValue: { value in
        print("receiveValue (sink) : \(value)")
    })
    
    subject.send("hello ,world.")
    subject.send("hello ,world2222.")
    
    // 进行取消sink订阅后，后续的 subject 发布数据将不被sink接受。
    subscription.cancel()
    subscriber.cancel()
    
//        let sink = Subscribers.Sink<String, MyError> { _ in
//            //
//        } receiveValue: {
//            //
//        }
//        sink.cancel()
    
    subject.send("hello ,world.3333")
    
    subject.send(completion: .finished)
//    subject.send(completion: .failure(.stringError))
}

/// 对PassthroughSubject进行 store 方法存储的subscriptions 订阅取消。
testSample(label: "Subject sample 3" ) {
    
    enum MyError: Error {
        case stringError
    }
    
    final class StringSubscriber : Subscriber {
        typealias Input = String
        typealias Failure = MyError
        
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
        }
        func receive(_ input: String) -> Subscribers.Demand {
            print("receive value : \(input)")
            return .unlimited
        }
        func receive(completion: Subscribers.Completion<MyError>) {
            print("completion : \(completion)")
        }
    }
    
    let subscriber = StringSubscriber()
    
    let subject = PassthroughSubject<String, MyError>()
    
    subject.subscribe(subscriber)
    
    var subscriptions = Set<AnyCancellable>()
    
    subject.sink(receiveCompletion: { completion in
        /// Subscribers.Completion<Self.Failure>
        switch(completion) {
            case .finished :
                print("receiveCompletion (sink) finished.")
            case .failure(let error) :
            print("receiveCompletion error (sink) : \(error)")
        }
    }, receiveValue: { value in
        print("receiveValue (sink) : \(value)")
    }).store(in: &subscriptions)
    
    subject.send("hello ,world.")
    subject.send("hello ,world2222.")
    
    // store 方法存储的subscriptions 进行取消sink订阅后，后续的 subject 发布数据将不被sink接受。
    subscriptions.first?.cancel()
    
    subject.send("hello ,world.3333")
    
    subject.send(completion: .finished)
//    subject.send(completion: .failure(.stringError))
}
 
/// 对CurrentValueSubject # value 的使用方法
testSample(label: "Subject sample 4" ) {
    
    enum MyError: Error {
        case stringError
    }
    
    final class StringSubscriber : Subscriber {
        typealias Input = String
        typealias Failure = MyError
        
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
        }
        func receive(_ input: String) -> Subscribers.Demand {
            print("receive value : \(input)")
            return .unlimited
        }
        func receive(completion: Subscribers.Completion<MyError>) {
            print("completion : \(completion)")
        }
    }
    
    let subscriber = StringSubscriber()
    
    let subject = CurrentValueSubject<String, MyError>("me")
    
    subject.subscribe(subscriber)
    
    subject.sink(receiveCompletion: { completion in
        /// Subscribers.Completion<Self.Failure>
        switch(completion) {
            case .finished :
                print("receiveCompletion (sink) finished.")
            case .failure(let error) :
            print("receiveCompletion error (sink) : \(error)")
        }
        
    }, receiveValue: { value in
        print("receiveValue (sink) : \(value)")
    })
 
    
    subject.send("hello ,world.")
    print("======", subject.value)
    subject.send("hello ,world2222.")
    print("======", subject.value)
    
    subject.send("hello ,world.3333")
    print("======", subject.value)
    
    subject.value = "setted by value"
    
    subject.send(completion: .finished)
}


