//
//  HTTPClientSession.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import Foundation
import Combine

public protocol HTTPClientSession {
    func dataTaskPublisherForURL(_ url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}
