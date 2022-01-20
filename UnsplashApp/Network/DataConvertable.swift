//
//  DataDecoder.swift
//  TestingByExample
//
//

import Foundation
import Combine

protocol DataConverterable: AnyObject {
    /**
     Decodes the given data via `JSONDecoder`.
     - Parameter data: Data to be decoded
     - Returns: A publisher, with either the decoded data on success, or a `NetworkError` on failure
     */
    func decode<T: Decodable>(_ data: Data, _ url: URL?) -> AnyPublisher<T, NetworkError>
}

class DataConverter: DataConverterable {
    /**
    Decodes the given data via `JSONDecoder`.
    - Parameter data: Data to be decoded
    - Returns: A publisher, with either the decoded data on success, or a `NetworkError` on failure
    */
    func decode<T: Decodable>(_ data: Data, _ url: URL?) -> AnyPublisher<T, NetworkError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            guard let _ = url else { return NetworkError.parsing(description: error.localizedDescription) }
            return NetworkError.parsing(description: error.localizedDescription)
            }
        .eraseToAnyPublisher()
    }
}
