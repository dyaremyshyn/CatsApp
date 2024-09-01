//
//  BreedsDataLoader.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation
import Combine

public protocol BreedsDataLoader {
    typealias Result = AnyPublisher<BreedsResponse, Error>
    
    func loadData(from url: URL, given client: HTTPClient) -> Result
}
