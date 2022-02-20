//: [Previous](@previous)

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("-----您正在演示:\(label)-----")
    testBlock()
    print("-----演示:\(label)结束-----")
}

/// https://developer.apple.com/documentation/combine/just
/// A publisher that emits an output to each subscriber just once, and then finishes.
/// Just 不会产生错误，只会发送一个单一的数据。
/// 体验 sink  和 assign 两个订阅者。
///
testSample(label: "Just sample" ) {
    
    let myPubliser = Just("55")
    
    let myScriber1 = Subscribers.Sink<String,Never> (receiveCompletion: { completion in
            if completion == .finished {
                print("myScriber1 Finished")
            } else {
                print("myScriber1 Failure")
            }
        }, receiveValue: { value in
            print(value)
        })

    let myScriber2 = Subscribers.Sink<String,Never> (receiveCompletion: { completion in
            if completion == .finished {
                print("myScriber2 Finished")
            } else {
                print("myScriber2 Failure")
            }
        }, receiveValue: { value in
            print(value)
        })
    
     myPubliser.subscribe(myScriber1)
     myPubliser.subscribe(myScriber2)
    /// Attaches the specified subscriber to this publisher.
    /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
//    myPubliser.receive(subscriber: myScriber1)
//    myPubliser.receive(subscriber: myScriber2)
}

testSample(label: "Just sample2" ) {
    let integers : ClosedRange<Int> = 0...3
    integers
        .publisher
        .sink {
            print("Received \($0)")
        }
}

testSample(label: "Just sample3" ) {
    let myRange : ClosedRange<Int>  = 0...3
    let cancellable = myRange.publisher
        .sink(receiveCompletion: {
                print ("completion: \($0)"
                )},
              receiveValue: {
                print ("value: \($0)")
        })
}

testSample(label: "Just sample4" ) {
    class MyClass {
        var anInt: Int = 0 {
            didSet {
                print("anInt 被复制为 : \(anInt)", terminator: "; \n")
            }
        }
    }

    let myObject = MyClass()
    let myRange  : ClosedRange<Int> = 0...2
    let cancellable = myRange
                        .publisher
                        .assign(to: \.anInt, on: myObject)
}


//testSample(label: "Just sample5" ) {
//    class MyModel: ObservableObject {
//        @Published var lastUpdated: Date = Date() // Calendar.current.date(byAdding: .day, value: -3, to: Date())!
//
//        init() {
//             Timer.publish(every: 1.0, on: .main, in: .common)
//                 .autoconnect()
//                 .assign(to: &$lastUpdated) /// public func assign(to published: inout Published<Self.Output>.Publisher)
//        }
//    }
//    let model = MyModel()
//    print(model.lastUpdated)
//
//}

testSample(label: "Just sample6" ) {
    class MyModel: ObservableObject {
        @Published var id: Int = 0
    }
    
    let model = MyModel()
    /// public func assign(to published: inout Published<Self.Output>.Publisher)
    Just(100).assign(to: &model.$id)
    print(model.id)
    
    let model2 = MyModel()
    Just(101).assign(to: \.id, on: model2)
    print(model2.id)
}

/// Future
testSample(label: "Future sample7" ) {
    let futurePubliser = Future<Int, Never> { promise in
        //异步执行 耗时操作
        print("i will promise soon")
        promise(.success(100))
    }
    let myScriber = Subscribers.Sink<Int,Never> (receiveCompletion: { completion in
            if completion == .finished {
                print("Finished")
            } else {
                print("Failure")
            }
        }, receiveValue: { value in
            print(value)
        })
    let myScriber2 = Subscribers.Sink<Int,Never> (receiveCompletion: { completion in
            if completion == .finished {
                print("222 Finished")
            } else {
                print("222 Failure")
            }
        }, receiveValue: { value in
            print(value)
        })
    
    futurePubliser.subscribe(myScriber)
    futurePubliser.subscribe(myScriber2)
    
    class MyModel {
        var id: Int = 0
    }
    
    let model = MyModel()
    futurePubliser.assign(to: \.id, on: model)
    print("model : \(model.id)")
}

//: [Next](@next)
