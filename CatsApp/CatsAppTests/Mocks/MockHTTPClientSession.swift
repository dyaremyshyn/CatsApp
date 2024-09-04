//
//  MockHTTPClientSession.swift
//  CatsAppTests
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import Foundation
import CatsApp
import Combine

class MockHTTPClientSession: HTTPClientSession {
    private struct Stub {
        let data: Data
        let response: URLResponse
        let error: URLError?
    }
    
    private var stubs: [URL: Stub] = [:]
    
    func stub(url: URL, data: Data, response: URLResponse, error: URLError? = nil) {
        stubs[url] = Stub(data: data, response: response, error: error)
    }
    
    func dataTaskPublisherForURL(_ url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        guard let stub = stubs[url] else {
            fatalError("No stub found for URL: \(url)")
        }
        
        if let error = stub.error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just((data: stub.data, response: stub.response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
    }
}
