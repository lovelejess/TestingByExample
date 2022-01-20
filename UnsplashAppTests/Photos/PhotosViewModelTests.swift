//
//  PhotosViewModelTests.swift
//  UnsplashAppTests
//
//

import XCTest
@testable import UnsplashApp

class PhotosViewModelTests: XCTestCase {

    private var viewModel: PhotosViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func test_getPhotos_returns_photoDescription() throws {
        let expected = "A man drinking a coffee."
        let actual = viewModel.getPhotos()

        XCTAssertEqual(actual, expected)

        print("JESS \(expected)")
    }
}
