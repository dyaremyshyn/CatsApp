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
    private var allBreeds: BreedsResponse?
    private var cancellables = Set<AnyCancellable>()
    
    private let client: HTTPClient
    private let breedsLoader: BreedsDataLoader
    private let persistenceLoader: PersistenceLoader
    private let selection: (CatBreed) -> Void

    init(client: HTTPClient, breedsLoader: BreedsDataLoader, persistenceLoader: PersistenceLoader, selection: @escaping (CatBreed) -> Void) {
        self.client = client
        self.breedsLoader = breedsLoader
        self.persistenceLoader = persistenceLoader
        self.selection = selection
    }

    public func loadData() {
        let persistedBreeds = persistenceLoader.getData()
        guard persistedBreeds.count > 0 else {
            fetchBreeds()
            return
        }
        fetchedBreeds = persistedBreeds
        allBreeds = persistedBreeds
    }
    
    public func selected(breed: CatBreed) {
        selection(breed)
    }
    
    public func toggleFavorite(breed: CatBreed) {
        // Apply favorite to displayed breeds
        if let index = fetchedBreeds?.firstIndex(where: { $0.id == breed.id }) {
            // Update breed in the array
            fetchedBreeds?[index].isFavorite.toggle()
            // Update breed in the DB
            persistenceLoader.saveData(catBreed: fetchedBreeds?[index])
        }
        // Apply favorite to array with all breeds
        if let index = allBreeds?.firstIndex(where: { $0.id == breed.id }) {
            // Update breed in the array
            allBreeds?[index].isFavorite.toggle()
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
                self.fetchedBreeds = response
                saveBreedToPersistence()
            }
            .store(in: &cancellables)
    }
    
    private func saveBreedToPersistence() {
        guard let allBreeds = allBreeds, allBreeds.count > 0 else { return }
        allBreeds.forEach {
            persistenceLoader.saveData(catBreed: $0)
        }
    }
}
