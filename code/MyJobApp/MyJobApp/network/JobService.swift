// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

protocol JobServiceable {
    
    func getJobList(req: GetJobListReq) -> AnyPublisher<GetJobListRes, NetworkError>
    func getJobDetails(req: GetJobDetailsReq) -> AnyPublisher<GetJobDetailsRes, NetworkError>
    func saveJobInfo(req: SaveJobInfoReq) -> AnyPublisher<SaveJobInfoRes, NetworkError>
    func acceptJob(req: AcceptJobReq) -> AnyPublisher<AcceptJobRes, NetworkError>
}

class JobService: JobServiceable {
    
    private var networkRequest: Requestable
    private var environment: Environment = .development
    
    init(networkRequest: Requestable, environment: Environment = .development) {
        self.networkRequest = networkRequest
        self.environment = environment
    }
    
    func getJobList(req: GetJobListReq) -> AnyPublisher<GetJobListRes, NetworkError> {
        let urlParam = "?token=\(req.header.token)"
        let endpoint = PurchaseServiceEndpoints.getJobList(urlParams: urlParam)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.shareRequest(request)
    }
    
    func getJobDetails(req: GetJobDetailsReq) -> AnyPublisher<GetJobDetailsRes, NetworkError> {
        let endpoint = PurchaseServiceEndpoints.getJobDetails(request: req)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
    
    func saveJobInfo(req: SaveJobInfoReq) -> AnyPublisher<SaveJobInfoRes, NetworkError> {
        let endpoint = PurchaseServiceEndpoints.saveJobInfo(request: req)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
    
    func acceptJob(req: AcceptJobReq) -> AnyPublisher<AcceptJobRes, NetworkError> {
        let endpoint = PurchaseServiceEndpoints.acceptJob(request: req)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
}

