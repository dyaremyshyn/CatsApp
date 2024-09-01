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
                self.fetchedBreeds = response
            }
            .store(in: &cancellables)
    }
}
