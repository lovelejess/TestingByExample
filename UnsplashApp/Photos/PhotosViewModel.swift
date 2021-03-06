//
//  PhotosViewModel.swift
//  UnsplashApp
//
//  Created by Jess Le on 1/19/22.
//

import Foundation
import Combine

class PhotosViewModel {

    private var unsplashFetcher: UnsplashFetcherable!
    private var subscribers = [AnyCancellable]()

    @Published
    var photoDescription: String = ""

    init(unsplashFetcher: UnsplashFetcherable) {
        self.unsplashFetcher = unsplashFetcher
        getPhotos()
    }

    /// Retrieves photos from the Unsplash API.
    /// Once values are retrieved, it publishes the values via `photoDescription`
    //
    /// - Returns: A publisher of type `<Photos, NetworkError>` used to return `Photos`
    func getPhotos() {
        unsplashFetcher.photos()
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.photoDescription = "error!"
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }

                // TODO: get the entire array and map it
                self.photoDescription = response[0].id
            })
            .store(in: &subscribers)
    }
}
