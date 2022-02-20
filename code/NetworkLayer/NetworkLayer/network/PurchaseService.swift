// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

protocol PurchaseServiceable {
    
    func getProduct(product: ProductInfoReq) -> AnyPublisher<ProductInfoRes, NetworkError>
    func purchaseProduct(purchase: PurchaseReq) -> AnyPublisher<PurchaseRes, NetworkError>
    func cancelOrder(order: CancelOrderReq) -> AnyPublisher<CancelOrderRes, NetworkError>
}

class PurchaseService: PurchaseServiceable {
    
    private var networkRequest: Requestable
    private var environment: Environment = .development
    
    init(networkRequest: Requestable, environment: Environment = .development) {
        self.networkRequest = networkRequest
        self.environment = environment
    }
    
    func getProduct(product: ProductInfoReq) -> AnyPublisher<ProductInfoRes, NetworkError> {
        let endpoint = PurchaseServiceEndpoints.getProduct(request: product)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
    
    func purchaseProduct(purchase: PurchaseReq) -> AnyPublisher<PurchaseRes, NetworkError> {
        let endpoint = PurchaseServiceEndpoints.purchaseProduct(request: purchase)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
    
    func cancelOrder(order: CancelOrderReq) -> AnyPublisher<CancelOrderRes, NetworkError> {
        let endpoint = PurchaseServiceEndpoints.cancelOrder(request: order)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
}

