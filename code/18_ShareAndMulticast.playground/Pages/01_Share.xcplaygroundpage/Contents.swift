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

testSample(label: "01_Share"){
    enum MyErrors : Error {
        case notfound
    }
    
    let sourcePublisher = PassthroughSubject<Int, MyErrors>()
    sourcePublisher
        .sink(receiveCompletion: { completion in
            print("01_Share completion:\(completion)")
        }, receiveValue: { value in
            print("01_Share value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher
        .sink(receiveCompletion: { completion in
            print("01_Share2 completion:\(completion)")
        }, receiveValue: { value in
            print("01_Share2 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    sourcePublisher.send(completion: .finished)
}

//// 这种复制过程的弱点在于资源密集型操作（例如网络请求）中，这可能导致性能不佳，因为结果将重复而不是共享。
testSample(label: "01_Share1"){
    
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        .publisher
        .share()
        .print()
    numbers
        .sink(receiveValue: { _ in })
        .store(in: &subscriptions)
    numbers
        .sink(receiveValue: { _ in })
        .store(in: &subscriptions)
}

testSample(label: "01_Share2"){
    
    struct ProductInfoRes: Codable {
        var productInfo: [ProductInfo]
    }

    struct ProductInfo: Codable {
        var productId: String
        var price: Int
    }

    let defalutProductInfo = ProductInfoRes(productInfo: [])
    
    let url = URL(string: "https://7a5fffa1-b400-4b2a-bf47-2e36ce89bf99.mock.pstmn.io/api/productInfo/0001")!
    let posts = URLSession.shared.dataTaskPublisher(for: url)
        .print()
        .map { $0.data }
        .decode(type: ProductInfoRes.self, decoder: JSONDecoder())
        .replaceError(with: defalutProductInfo)
        .share() /// share添加后，网络请求只会执行一次，如果没有的话，则会是 两次。
                 /// 使用“share（）”运算符实现网络请求将导致只向上游发布服务器进行一次订阅，因为唯一的资源将共享给下游订阅。
                 /// `share（）`运算符不涉及任何缓冲系统，这意味着如果第二次订阅发生在请求完成之后，它将只接收完成事件。
                 /// Combine使我们能够通过share 高效地管理的资源，提高应用程序性能。
    posts
        .sink(receiveValue: {
            print("subscription1 value: \($0)") })
        .store(in: &subscriptions)
    posts
        .sink(receiveValue: {
            print("subscription2 value: \($0)") })
        .store(in: &subscriptions)
}
