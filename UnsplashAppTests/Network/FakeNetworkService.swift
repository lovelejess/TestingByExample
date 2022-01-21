//
//  FakeNetworkService.swift
//  UnsplashAppTests
//

import Foundation
import Combine
@testable import UnsplashApp

class FakeNetworkService: Networkable {
    private let urlSession: URLSession
    var testDataForURL = [URL: Data]()

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func decode<T: Decodable>(_ data: Data, _ url: URL?, _ response: URLResponse) -> AnyPublisher<T, NetworkError> {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970
      return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
          NetworkError.parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }

    func taskForGetRequest<Output>(with request: URLRequest) -> AnyPublisher<Output, NetworkError> where Output: Decodable {
        if let data = testDataForURL[request.url!] {
            return decode(data, request.url!, URLResponse())
        }
        return decode(Data(), request.url!, URLResponse())
    }
}
