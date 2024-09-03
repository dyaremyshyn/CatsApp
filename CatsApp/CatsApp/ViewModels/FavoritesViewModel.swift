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
    @Published var averageLifeSpan: String?
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
        calculateAverageLifespan()
    }
    
    public func selected(breed: CatBreed) {
        selection(breed)
    }
    
    public func toggleFavorite(breed: CatBreed) {
        // Apply favorite to displayed breeds
        if let index = favoriteBreeds?.firstIndex(where: { $0.id == breed.id }) {
            // Update breed in the array
            favoriteBreeds?[index].isFavorite.toggle()
            // Update breed in the DB
            persistenceLoader.saveData(catBreed: favoriteBreeds?[index])
            // Remove from the array, cause its only for favorites
            removeFromFavorite(index: index)
        }
        calculateAverageLifespan()
    }
    
    private func removeFromFavorite(index: Int) {
        favoriteBreeds?.remove(at: index)
    }
    
    private func calculateAverageLifespan() {
        var totalSum = 0.0
        var count = 0
        
        favoriteBreeds?.forEach {
            print($0.lifeSpan)
            let components = $0.lifeSpan?.split(separator: "-").map { $0.trimmingCharacters(in: .whitespaces) }
                    
            if let minValue = Int(components?[0] ?? "0"), let maxValue = Int(components?[1] ?? "0") {
                // Calculate the average of the min and max values
                let average = Double(minValue + maxValue) / 2.0
                totalSum += average
                count += 1
            }
        }
        
        // Calculate the overall average
        let overallAverage = count > 0 ? totalSum / Double(count) : 0
        
        // Assigne the result to binded property
        averageLifeSpan = "Average lifespan: \(overallAverage) years"
    }
}
