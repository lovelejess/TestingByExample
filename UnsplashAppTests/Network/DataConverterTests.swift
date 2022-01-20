//
//  DataConverterTests.swift
//  UnsplashAppTests
//
//

import XCTest
import Combine

@testable import UnsplashApp

class DataConverterTests: XCTestCase {

    private var dataConverter: DataConverter!
    private var subscribers = [AnyCancellable]()

    override func setUpWithError() throws {
        dataConverter = DataConverter()
    }

    func test_decode_success() throws {
        let expectation = XCTestExpectation(description: "Successfully Decodes")
        guard let data = FakeJSONLoader.loadFile(for: "FakePhotosData") else { XCTFail("Unable load mock data");return }

        let expected = Photos(id: "LBI7cgq3pbM")

        let url = UnsplashFetcher.Endpoints.photos.url

        dataConverter.decode(data, url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
              switch value {
              case .failure:
                XCTFail("Failed to get successful results")
              case .finished:
                XCTAssertNotNil(value)
                expectation.fulfill()
              }
            }, receiveValue: { (response: Photos) in
                XCTAssertEqual(response.id, expected.id)
                expectation.fulfill()
            })
            .store(in: &subscribers)
            wait(for: [expectation], timeout: 5.0)
    }

    func test_decode_withEmptyData_returns_networkParsingError() throws {
        let expectation = XCTestExpectation(description: "Fails to Decode")
        guard let data = FakeJSONLoader.loadFile(for: "FakeFailureData") else { XCTFail("Unable load mock data");return }
        let url = UnsplashFetcher.Endpoints.photos.url
//        let expected = Just(NetworkError.parsing(description: ""))


        dataConverter.decode(data, url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { actual in
              switch actual {
              case .failure:
                  // TODO: Find type of to assert that the type is network error
//                  XCTAssertEqual(actual, expected)
                  expectation.fulfill()
              case .finished:
                  XCTFail("Test should cause a failure")
              }
            }, receiveValue: { (response: Photos) in
                XCTFail("Test should cause a failure")
            })
            .store(in: &subscribers)
            wait(for: [expectation], timeout: 5.0)
    }
}
