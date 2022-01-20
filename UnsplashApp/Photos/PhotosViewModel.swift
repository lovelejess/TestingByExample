//
//  PhotosViewModel.swift
//  UnsplashApp
//
//  Created by Jess Le on 1/19/22.
//

import Foundation

class PhotosViewModel {

    func getPhotos() -> String {
        // make network call to get photos
        // parse data
        // get photo description
//        return UnsplashFetcher.Endpoints.photos.url.description
        return "FAILURE"
    }
}

struct Photos: Codable {
    var id: String
}
