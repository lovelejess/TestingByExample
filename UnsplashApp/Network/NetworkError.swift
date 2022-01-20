//
//  NetworkError.swift
//  UnsplashApp
//
//

import Foundation

enum NetworkError: Error {
    case parsing(description: String)
    case networking(description: String)
}
