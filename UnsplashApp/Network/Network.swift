//
//  Network.swift
//  UnsplashApp
//
//

import Foundation
import Combine

protocol Networkable: AnyObject {
    /**
     Performs a GET request for the given `URLRequest` and maps the response to the given Output type
     - Parameter request: The `URLRequest` used to make the request
     - Returns: A publisher, with either the mapped Output on success,  or a `NetworkError` on failure
     */
    func taskForGetRequest<Output>(with request: URLRequest) -> AnyPublisher<Output, NetworkError> where Output: Decodable
}

/**
A concrete implementation of `Networkable` that is used for accessing the network data layer
*/
public class NetworkService: Networkable {
    private let urlSession: URLSession
    private let dataConverter: DataConverterable

    init(urlSession: URLSession, dataConverter: DataConverterable) {
        self.urlSession = urlSession
        self.dataConverter = dataConverter
    }

    /**
    Performs a Get Request for the given URLRequest and decodes and maps the response to the given `Output `type
    - Parameter request: The URLRequest used to make the request
    - Returns: A publisher, with either the mapped `Output` on success,  or a `NetworkError` on failure
    */
    func taskForGetRequest<Output>(with request: URLRequest) -> AnyPublisher<Output, NetworkError> where Output: Decodable {
        return urlSession
            .dataTaskPublisher(for: request)
            .mapError { error in
                return NetworkError.networking(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { data, response in
                self.dataConverter.decode(data, request.url, response)
            }
            .eraseToAnyPublisher()
    }
}
