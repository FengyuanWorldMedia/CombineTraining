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
 
testSample(label: "02_Connectable"){
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
        .map { $0.data }
        .decode(type: ProductInfoRes.self, decoder: JSONDecoder())
        .replaceError(with: defalutProductInfo)
        .print()
        .share() ///　从测试结果来看，这里share 可以省略，因为 receive value 次数只有一次。
        .makeConnectable() /// 让发布者Publisher 可以使用 connect方法，一起让订阅有效。
    /// 订阅1
    posts
        .sink(receiveValue: {
            print("02_Connectable value 1: \($0)") })
        .store(in: &subscriptions)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        /// 订阅2
        posts
            .sink(receiveValue: { print("02_Connectable value 2: \($0)") })
            .store(in: &subscriptions)
        /// connect订阅有效
         posts /// 因为sahre不提供 缓存的机制，publisher完成后，第二个订阅 就只能接受完成事件，connect可以保证publisher 的订阅可以 一起有效。
            .connect()
            .store(in: &subscriptions)
    }
}
