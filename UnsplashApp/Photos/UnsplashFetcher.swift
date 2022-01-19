//
//  UnsplashFetcher.swift
//  UnsplashApp
//
//  Created by Jess Le on 1/19/22.
//

import Foundation

class UnsplashFetcher {
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
