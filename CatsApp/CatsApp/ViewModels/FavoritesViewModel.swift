//
//  FavoritesViewModel.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 02/09/2024.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favoriteBreeds: BreedsResponse?
    private var cancellables = Set<AnyCancellable>()
    
    private let persistenceLoader: PersistenceLoader
    private let selection: (CatBreed) -> Void

    init(persistenceLoader: PersistenceLoader, selection: @escaping (CatBreed) -> Void) {
        self.persistenceLoader = persistenceLoader
        self.selection = selection
    }

    public func loadData() {
        let allBreeds = persistenceLoader.getData()
        favoriteBreeds = allBreeds.filter { $0.isFavorite }
    }
    
    public func selected(breed: CatBreed) {
        selection(breed)
    }
    
    public func toggleFavorite(breed: CatBreed, isFavorite: Bool) {
        // Apply favorite to displayed breeds
        if let index = favoriteBreeds?.firstIndex(where: { $0.id == breed.id }) {
            // Update breed in the array
            favoriteBreeds?[index].isFavorite = isFavorite
            // Update breed in the DB
            persistenceLoader.saveData(catBreed: favoriteBreeds?[index])
            // Remove from the array, cause its only for favorites
            removeFromFavorite(index: index)
        }
    }
    
    private func removeFromFavorite(index: Int) {
        favoriteBreeds?.remove(at: index)
    }
}
