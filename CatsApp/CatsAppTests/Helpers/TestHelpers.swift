//
//  TestHelpers.swift
//  CatsAppTests
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import Foundation
@testable import CatsApp

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURLError() -> URLError {
    return URLError(.networkConnectionLost)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func emptyData() -> Data {
    return Data()
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func someBreeds() -> [CatBreed] {
    return [
        CatBreed(id: "id1", name: "name1", temperament: "temperament", origin: "origin", description: "description", lifeSpan: "1 - 2", referenceImageID: "ref 1", image: nil, isFavorite: false),
        CatBreed(id: "id2", name: "name2", temperament: "temperament", origin: "origin", description: "description", lifeSpan: "1 - 2", referenceImageID: "ref 2", image: nil, isFavorite: false)
    ]
}

func errorMessage() -> String {
    return "Network Error"
}
