// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

public typealias Headers = [String: String]

enum PurchaseServiceEndpoints {
    
    case getProduct(request: ProductInfoReq)
    case purchaseProduct(request: PurchaseReq)
    case cancelOrder(request: CancelOrderReq)
    
    var requestTimeOut: Int {
        return 20
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .purchaseProduct, .cancelOrder:
            return .POST
        case .getProduct:
            return .POST
        }
    }
    
    func createRequest(token: String = "random token", environment: Environment) -> NetworkRequest {
        var headers: Headers = [:]
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(token)"
        return NetworkRequest(url: getURL(from: environment), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getProduct(let request):
            return request
        case .purchaseProduct(let request):
            return request
        case .cancelOrder(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(from environment: Environment) -> String {
        let baseUrl = environment.serviceBaseUrl
        switch self {
        case .purchaseProduct:
            return "\(baseUrl)/purchase"
        case .getProduct:
            return "\(baseUrl)/productInfo"
        case .cancelOrder:
            return "\(baseUrl)/order/cancel"
        }
    }
}
