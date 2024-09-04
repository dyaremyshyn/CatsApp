//
//  URLSessionHTTPClient.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation
import Combine

public final class URLSessionHTTPClient: HTTPClient {

    private let session: HTTPClientSession
    
    public init(session: HTTPClientSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    public func get(from url: URL) -> HTTPClient.Publisher {
        return session.dataTaskPublisherForURL(url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw UnexpectedValuesRepresentation()
                }
                return (data, httpResponse)
            }
            .eraseToAnyPublisher()
    }
}
