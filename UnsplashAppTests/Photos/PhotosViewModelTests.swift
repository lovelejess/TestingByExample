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
        viewModel = PhotosViewModel()
    }

    func test_getPhotos_returns_photoDescription() throws {
        let expected = "A man drinking a coffee."
        let actual = viewModel.getPhotos()

        XCTAssertEqual(actual, expected)
        XCTFail("Missing implementation")
    }
}
