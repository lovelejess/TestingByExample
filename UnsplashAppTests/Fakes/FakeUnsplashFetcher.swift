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

    static var photosPublisher: AnyPublisher<[Photo], NetworkError> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }

    init(networkService: Networkable) {
        self.networkService = networkService
    }

    /// Returns a static fake publisher immediately of either type `Photos` or `NetworkError`
    ///
    /// - Returns: A publisher of type `<Photos, NetworkError>` used to return `Photos`
    func photos() -> AnyPublisher<[Photo], NetworkError> {

        let photos = [ Photo(id: "LBI7cgq3pbM", description: "") ]
        return Just(photos)
            .setFailureType(to: NetworkError.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
