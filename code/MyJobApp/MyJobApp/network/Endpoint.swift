// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

public typealias Headers = [String: String]

enum PurchaseServiceEndpoints {
    
    case getJobList(urlParams: String)
    case getJobDetails(request: GetJobDetailsReq)
    case saveJobInfo(request: SaveJobInfoReq)
    case acceptJob(request: AcceptJobReq)
    
    var requestTimeOut: Int {
        return 20
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getJobList:
            return .GET
        case .getJobDetails, .saveJobInfo , .acceptJob:
            return .POST
        }
    }
    
    func createRequest(token: String = "random token", environment: Environment) -> NetworkRequest {
        var headers: Headers = [:]
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(token)"
        
        if case .getJobList = self {
            return NetworkRequest(url: getURL(from: environment),
                                  urlParams : urlParam,
                                  headers: headers,
                                  httpMethod: httpMethod)
        } else {
            return NetworkRequest(url: getURL(from: environment),
                                  headers: headers,
                                  reqBody: requestBody,
                                  httpMethod: httpMethod)
        }
    }
    
    var urlParam: String? {
        switch self {
        case .getJobList(let urlParam):
            return urlParam
        default:
            return nil
        }
    }
    
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getJobList(_):
            return nil
        case .getJobDetails(let request):
            return request
        case .saveJobInfo(let request):
            return request
        case .acceptJob(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(from environment: Environment) -> String {
        let baseUrl = environment.serviceBaseUrl
        switch self {
        case .getJobList:
            return "\(baseUrl)/joblist"
        case .getJobDetails:
            return "\(baseUrl)/jobinfo"
        case .saveJobInfo:
            return "\(baseUrl)/saveJobInfo"
        case .acceptJob:
            return "\(baseUrl)/acceptjob"
        }
    }
}
