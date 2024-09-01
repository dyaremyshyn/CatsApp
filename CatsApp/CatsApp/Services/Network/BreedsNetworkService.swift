//
//  BreedsNetworkService.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation

struct BreedsNetworkService: BreedsDataLoader {
        
    func loadData(from url: URL, given client: HTTPClient) -> BreedsDataLoader.Result {
        return client.get(from: url)
            .map(\.0)
            .decode(type: BreedsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
