// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine 

public class NativeRequestable: Requestable {
    
    public var requestDefalutTimeOut: Float = 30

    /// where T: Decodable, T: Encodable
    /// where T: Codable
    ///
    public func request<T>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError> where T: Codable {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestDefalutTimeOut)
        
        guard let url = URL(string: req.url) else {
            // Return a fail publisher if the url is invalid
            /// 注意这里的 Fail Publisher 的使用。
            return AnyPublisher(Fail<T, NetworkError>(error: NetworkError.badURL("Invalid Url")))
        }
        
        // We use the dataTaskPublisher from the URLSession which gives us a publisher to play around with.
        return URLSession.shared
            .dataTaskPublisher(for: req.buildURLRequest(with: url))
            .subscribe(on: DispatchQueue.global())
            .tryMap { output in
                // throw an error if response is nil
                guard output.response is HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, error: "Server error")
                }
                print("output.data:\(output.data)")
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder()) /// Decodes the output from the upstream using a specified decoder.
            .mapError { error in
                /// 注意这里是和 tryMap 配合。
                /// Converts any failure from the upstream publisher into a new error.
                /// public func mapError<E>(_ transform: @escaping (Self.Failure) -> E) -> Publishers.MapError<Self, E> where E : Error
                ///
                /// return error if json decoding fails
                /// mapError serverError(code: 0, error: "Server error")
                print("mapError \(error)")
                return NetworkError.invalidJSON(String(describing: error))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        /// 这里使用到的 dataTaskPublisher，tryMap，decode ，mapError 都是对上一个 Publisher 的 再次包装。
        
    }
    
    
    /// where T: Decodable, T: Encodable
    /// where T: Codable
    ///
    public func shareRequest<T>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError> where T: Codable {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestDefalutTimeOut)
        
        guard let url = URL(string: req.url) else {
            return AnyPublisher(Fail<T, NetworkError>(error: NetworkError.badURL("Invalid Url")))
        }
        
        // We use the dataTaskPublisher from the URLSession which gives us a publisher to play around with.
        return URLSession.shared
            .dataTaskPublisher(for: req.buildURLRequest(with: url))
            // .print() For debug
            .share()
            .subscribe(on: DispatchQueue.global())
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, error: "Server error")
                }
                print("output.data:\(output.data)")
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                print("mapError \(error)")
                return NetworkError.invalidJSON(String(describing: error))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
}
