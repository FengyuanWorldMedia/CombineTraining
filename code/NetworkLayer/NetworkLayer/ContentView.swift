// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import SwiftUI
import Combine

struct ContentView: View {
    /// 体会 subscriptions 的作用。
    @State private var subscriptions = Set<AnyCancellable>()
    
    @State private var service = PurchaseService(networkRequest: NativeRequestable())
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Button("获取商品信息", action: {
                getProductInfo()
            })
            Button("支付", action: {
                purchase()
            })
            Button("取消订单", action: {
                cancelOrder()
            })
            
        }
    }
         
    func getProductInfo() {
        let productInfoReq = ProductInfoReq(productId: "ce0001", queryCond: "small size")
        service.getProduct(product: productInfoReq)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("getProductInfo error \(error.localizedDescription)")
                case .finished:
                    print("getProductInfo finished")
                }
            } receiveValue: { (response) in
                print("ResponseBody:\(response)")
            }
            .store(in: &self.subscriptions)
    }
    
    func purchase() {
        let purchaseRequest = PurchaseReq(productIds: ["productId1","productId2"], cost: 500)
        service.purchaseProduct(purchase: purchaseRequest)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("purchase \(error.localizedDescription)")
                case .finished:
                    print("purchase finished")
                }
            } receiveValue: { (response) in
                print("ResponseBody:\(response)")
            }
            .store(in: &self.subscriptions)
    }
    
    func cancelOrder() {
        let cancelOrderReq = CancelOrderReq(orderId: "productId1",  reason: "service is not good")
        service.cancelOrder(order: cancelOrderReq)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("cancelOrder error \(error.localizedDescription)")
                case .finished:
                    print("cancelOrder finished")
                }
            } receiveValue: { (response) in
                print("ResponseBody:\(response)")
            }
            .store(in: &self.subscriptions)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
