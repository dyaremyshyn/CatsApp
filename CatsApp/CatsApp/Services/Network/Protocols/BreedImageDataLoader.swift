//
//  BreedImageDataLoader.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import Foundation
import Combine

public struct BreedImage: Decodable {
    let id: String
    let url: String
}

public protocol BreedImageDataLoader {
    typealias Result = AnyPublisher<CatImage, Error>
    
    func loadData(from url: URL, given client: HTTPClient) -> Result
}
