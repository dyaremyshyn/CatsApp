//
//  CatsAppTests.swift
//  CatsAppTests
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import XCTest
@testable import CatsApp

final class CatsAppTests: XCTestCase {

    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let (sut, window) = makeSUT()
        
        sut.configureWindow()
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: SceneDelegate, window: UIWindowSpy) {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
        
        trackForMemoryLeaks(sut)
        
        return (sut, window)
    }
}

private class UIWindowSpy: UIWindow {
    var makeKeyAndVisibleCallCount = 0
    
    override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount += 1
    }
}
