// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public protocol Requestable {
    
    var requestDefalutTimeOut: Float { get }
    
    func request<T: Codable>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
    func shareRequest<T: Codable>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
}
