//
//  PhotosViewModelTests.swift
//  UnsplashAppTests
//

import XCTest
import Combine
@testable import UnsplashApp

class PhotosViewModelTests: XCTestCase {

    private var viewModel: PhotosViewModel!
    private var urlSessionMock: URLSession!
    private var fakeUnsplashFetcher: FakeUnsplashFetcher!
    private var fakeNetworkService: FakeNetworkService!
    private var subscribers = [AnyCancellable]()

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FakeURLProtocol.self]
        urlSessionMock = URLSession(configuration: config)
        fakeNetworkService = FakeNetworkService(urlSession: urlSessionMock)
        fakeUnsplashFetcher = FakeUnsplashFetcher(networkService: fakeNetworkService)

    }

    func test_getPhotos_returns_photos() throws {
        let expectation = XCTestExpectation(description: "Successfully Gets Photo Desscription")
        let expected = "LBI7cgq3pbM"

        viewModel = PhotosViewModel(unsplashFetcher: fakeUnsplashFetcher)

        viewModel.getPhotos()

        viewModel.$photoDescription
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                  XCTFail("Failed to get successful results")
                case .finished:
                  XCTAssertNotNil(value)
                  expectation.fulfill()
                }
              }, receiveValue: { actual in
                  XCTAssertEqual(actual, expected)
                  expectation.fulfill()
              })
              .store(in: &subscribers)
              wait(for: [expectation], timeout: 5.0)
    }
}
