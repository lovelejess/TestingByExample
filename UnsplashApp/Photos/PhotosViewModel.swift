//
//  PhotosViewModel.swift
//  UnsplashApp
//
//  Created by Jess Le on 1/19/22.
//

import Foundation

class PhotosViewModel {

    func getPhotos() -> String {
        return UnsplashFetcher.Endpoints.photos.url.description
    }
}
