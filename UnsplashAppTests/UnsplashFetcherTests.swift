//
//  UnsplashFetcherTests.swift
//  UnsplashAppTests
//
//  Created by Jess Le on 1/19/22.
//

import XCTest
@testable import UnsplashApp

class UnsplashFetcherTests: XCTestCase {
    private var unsplashFetcher: UnsplashFetcher!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

}
