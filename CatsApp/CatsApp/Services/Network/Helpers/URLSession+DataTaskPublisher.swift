//
//  URLSession+DataTaskPublisher.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import Foundation
import Combine

extension URLSession: HTTPClientSession {
    public func dataTaskPublisherForURL(_ url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        dataTaskPublisher(for: url)
            .mapError { $0 as URLError }
            .eraseToAnyPublisher()
    }
}
