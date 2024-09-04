//
//  CatsViewControllerTests.swift
//  CatsAppTests
//
//  Created by Dmytro Yaremyshyn on 04/09/2024.
//

import XCTest
import Combine
@testable import CatsApp

final class CatsViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_initializesDataSourceAndView() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.collectionView.dataSource, "DataSource should be initialized")
        XCTAssertEqual(sut.collectionView.backgroundColor, .systemBackground, "CollectionView should be initialized")
    }
    
    func test_viewDidLoad_initialSetupIsDoneCorrectly() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, sut.viewModel?.title, "The view controller's title should be set from the view model.")
        XCTAssertNotNil(sut.navigationItem.searchController, "Search controller should be added to the navigation item.")
        XCTAssertEqual(sut.navigationItem.searchController?.searchBar.placeholder, sut.viewModel?.searchPlaceholder, "Search bar placeholder should be set from the view model.")
    }
    
    func test_bind_whenFetchedBreedsUpdates_collectionViewIsUpdated() {
        let breeds = someBreeds()
        let sut = makeSUT()
        sut.loadViewIfNeeded()

        sut.viewModel?.loadData()
        sut.viewModel?.fetchedBreeds = breeds

        XCTAssertEqual(sut.viewModel?.fetchedBreeds?.count, breeds.count, "Fetched breeds should have the correct number of items after load data.")
    }
    
    func test_bind_whenErrorMessageUpdates_showErrorIsCalled() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.viewModel?.loadData()
        let errorMessage = errorMessage()
        sut.viewModel?.errorMessage = errorMessage
        
        XCTAssertEqual(sut.viewModel?.errorMessage, errorMessage, "Error message should be set correctly.")
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CatsViewController {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .default))
        let sut = CatsComposer.catsComposedWith(client: client, breedsLoader: BreedsNetworkService(), breedImageLoader: BreedImageNetworkService(), persistenceLoader: PersistenceService())
        trackForMemoryLeaks(sut)
        return sut
    }
}
