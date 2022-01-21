//
//  FakeUnsplashFetcher.swift
//  UnsplashAppTests
//
//

import Foundation
import Combine
@testable import UnsplashApp

class FakeUnsplashFetcher: UnsplashFetcherable {

    private let networkService: Networkable!

    init(networkService: Networkable) {
        self.networkService = networkService
    }

    func photos() -> AnyPublisher<[Photo], NetworkError> {
        let urlRequest = URLRequest(url: UnsplashFetcher.Endpoints.photos.url)
        return networkService.taskForGetRequest(with: urlRequest)
    }
}
