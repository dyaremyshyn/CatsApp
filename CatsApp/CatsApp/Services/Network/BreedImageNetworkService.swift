//
//  BreedImageNetworkService.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import Foundation

struct BreedImageNetworkService: BreedImageDataLoader {
        
    func loadData(from url: URL, given client: HTTPClient) -> BreedImageDataLoader.Result {
        return client.get(from: url)
            .map(\.0)
            .decode(type: CatImage.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
