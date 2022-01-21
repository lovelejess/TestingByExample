//
//  UnsplashFetcher.swift
//  UnsplashApp
//
//  Created by Jess Le on 1/19/22.
//

import Foundation
import Combine

protocol UnsplashFetcherable: AnyObject {
    /// Returns a publisher for `Photos`
    ///
    /// - Returns: A publisher of type `<Photos, NetworkError>` used to return `Photos`
    func photos() -> AnyPublisher<[Photo], NetworkError>
}

class UnsplashFetcher: UnsplashFetcherable {
    private let networkService: Networkable!

    init(networkService: Networkable) {
        self.networkService = networkService
    }

    func photos() -> AnyPublisher<[Photo], NetworkError> {
        let urlRequest = URLRequest(url: UnsplashFetcher.Endpoints.photos.url)
        return networkService.taskForGetRequest(with: urlRequest)
    }
}

extension UnsplashFetcher {
    enum Endpoints {
        static let scheme = "https"
        private static var host: String = "api.unsplash.com"
        private static var clientId: String = "gCei2QjPLIAK6qZ9xXxPUZUeXUAXBxHS1fAiugzGwR8"
        private static var clientIdQuery = URLQueryItem(name: "client_id", value: clientId)

        case photos

        private var path: String {
            switch self {
            case .photos: return "/photos/"
            }
        }

        var url: URL {
            var urlComponents: URLComponents
            switch self {
            case .photos:
                urlComponents = URLComponents()
                urlComponents.host = Endpoints.host
                urlComponents.path = path
                urlComponents.queryItems = [ Endpoints.clientIdQuery ]
            }
            urlComponents.scheme = Endpoints.scheme
            return urlComponents.url!
        }
    }
}
