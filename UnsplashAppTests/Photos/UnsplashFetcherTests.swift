//
//  UnsplashFetcherTests.swift
//  UnsplashAppTests
//
//

import XCTest
import Combine
@testable import UnsplashApp

class UnsplashFetcherTests: XCTestCase {
    private var unsplashFetcher: UnsplashFetcher!
    private var urlSessionMock: URLSession!
    private var fakeNetworkService: FakeNetworkService!
    private var subscribers = [AnyCancellable]()

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FakeURLProtocol.self]
        urlSessionMock = URLSession(configuration: config)
        fakeNetworkService = FakeNetworkService(urlSession: urlSessionMock)
        unsplashFetcher = UnsplashFetcher(networkService: fakeNetworkService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GETPhotosEndpoint_returnsCorrectURL() throws {
        let expectedURL = "https://api.unsplash.com/photos/?client_id=gCei2QjPLIAK6qZ9xXxPUZUeXUAXBxHS1fAiugzGwR8"
        let expectedComponents = try XCTUnwrap(URLComponents(string: expectedURL))

        let actual = try XCTUnwrap(UnsplashFetcher.Endpoints.photos.url)
        let actualComponents = try XCTUnwrap(URLComponents(url: actual, resolvingAgainstBaseURL: true))

        XCTAssertEqual(actualComponents.host, expectedComponents.host)
        XCTAssertEqual(actualComponents.path, expectedComponents.path)
    }

    func test_GETPhotos_successfullyRetreivesData() throws {
        let expectation = XCTestExpectation(description: "Complete Get Photos")
        guard let mockData = FakeJSONLoader.loadFile(for: "FakePhotosData") else { XCTFail("Unable load mock data");return }
        let url = UnsplashFetcher.Endpoints.photos.url

        fakeNetworkService.testDataForURL.updateValue(mockData, forKey: url)
        unsplashFetcher
            .photos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
              switch value {
              case .failure:
                XCTFail("Failed to get successful results")
              case .finished:
                XCTAssertNotNil(value)
                expectation.fulfill()
              }
            }, receiveValue: { response in
                XCTAssertNotNil(response)
                expectation.fulfill()
            })
            .store(in: &subscribers)
            wait(for: [expectation], timeout: 5.0)
    }

    func test_GETPhotos_failsToRetreiveData() throws {
        let expectation = XCTestExpectation(description: "Fails to Get Photos")
        guard let mockData = FakeJSONLoader.loadFile(for: "FakeFailureData") else { XCTFail("Unable load mock data");return }
        let url = UnsplashFetcher.Endpoints.photos.url
        fakeNetworkService.testDataForURL.updateValue(mockData, forKey: url)

        unsplashFetcher
            .photos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
              switch value {
              case .failure:
                expectation.fulfill()
              case .finished:
                XCTFail("Test should cause a failure")
              }
            }, receiveValue: { _ in
                XCTFail("Test should cause a failure")
            })
            .store(in: &subscribers)
            wait(for: [expectation], timeout: 5.0)
    }
}
