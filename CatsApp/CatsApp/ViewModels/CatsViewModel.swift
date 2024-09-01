//
//  CatsViewModel.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation
import Combine

class CatsViewModel: ObservableObject {
    @Published var fetchedBreeds: BreedsResponse?
    @Published var errorMessage: String? = nil
    private var allBreeds: BreedsResponse? {
        willSet {
            fetchedBreeds = newValue
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    private let client: HTTPClient
    private let breedsLoader: BreedsDataLoader
    private let selection: (CatBreed) -> Void

    init(client: HTTPClient, breedsLoader: BreedsDataLoader, selection: @escaping (CatBreed) -> Void) {
        self.client = client
        self.breedsLoader = breedsLoader
        self.selection = selection
    }
    
    public var title: String {
        "Cats App"
    }
    
    public var searchPlaceholder: String {
        "Search"
    }

    public func loadData() {
        fetchBreeds()
    }
    
    public func selected(breed: CatBreed) {
        selection(breed)
    }
    
    public func toggleFavorite(breed: CatBreed, isFavorite: Bool) {
        // Apply favorite to given breed
        if let index = fetchedBreeds?.firstIndex(where: { $0.id == breed.id }) {
            fetchedBreeds?[index].isFavorite = isFavorite
        }
    }
    
    public func search(for breedName: String?) {
        if breedName?.isEmpty ?? true {
            fetchedBreeds = allBreeds
        } else {
            guard let breed = breedName else { return }
            fetchedBreeds = allBreeds?.filter { $0.name.lowercased().contains(breed.lowercased()) }
        }
    }
}

// MARK: - Data Loader
extension CatsViewModel {
    
    private func fetchBreeds() {
        guard let url = URL(string: NetworkHelper.breeds) else { return }

        breedsLoader.loadData(from: url, given: client)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished: ()
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.errorMessage = nil
                self.allBreeds = response
            }
            .store(in: &cancellables)
    }
}
