//
//  URLSessionHTTPClientTests.swift
//  CatsAppTests
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import XCTest
@testable import CatsApp
import Combine

final class URLSessionHTTPClientTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let (sut, session) = makeSUT()
        
        let data = anyData()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        session.stub(url: url, data: data, response: response)
        
        sut.get(from: url).sink(receiveCompletion: { _ in }, receiveValue: { receivedData, receivedResponse in
            XCTAssertEqual(receivedData, data)
            XCTAssertEqual(receivedResponse.url, response.url)
            XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
        }).store(in: &cancellables)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = anyURL()
        let (sut, session) = makeSUT()
        
        let error = anyURLError()
        session.stub(url: url, data: emptyData(), response: HTTPURLResponse(), error: error)
        
        let expectation = XCTestExpectation(description: "Wait for failure")
        
        sut.get(from: url).sink(receiveCompletion: { completion in
            if case let .failure(receivedError as URLError) = completion {
                XCTAssertEqual(receivedError.code, error.code)
                expectation.fulfill()
            } else {
                XCTFail("Expected failure, got \(completion) instead")
            }
        }, receiveValue: { _ in
            XCTFail("Expected failure, got value instead")
        }).store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnNonHTTPURLResponse() {
        let url = anyURL()
        let (sut, session) = makeSUT()
        
        session.stub(url: url, data: emptyData(), response: URLResponse())
        
        let expectation = XCTestExpectation(description: "Wait for failure")
        
        sut.get(from: url).sink(receiveCompletion: { completion in
            if case .failure = completion {
                expectation.fulfill()
            } else {
                XCTFail("Expected failure, got \(completion) instead")
            }
        }, receiveValue: { _ in
            XCTFail("Expected failure, got value instead")
        }).store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let url = anyURL()
        let (sut, session) = makeSUT()
        
        let data = anyData()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        session.stub(url: url, data: data, response: response)
        
        let expectation = XCTestExpectation(description: "Wait for success")
        
        sut.get(from: url).sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                XCTFail("Expected success, got \(error) instead")
            }
        }, receiveValue: { receivedData, receivedResponse in
            XCTAssertEqual(receivedData, data)
            XCTAssertEqual(receivedResponse.url, response.url)
            XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
            expectation.fulfill()
        }).store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: URLSessionHTTPClient, session: MockHTTPClientSession) {
        let session = MockHTTPClientSession()
        let sut = URLSessionHTTPClient(session: session)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(session)
        
        return (sut, session)
    }
}
