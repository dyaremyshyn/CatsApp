//
//  BreedDetailsViewModel.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 03/09/2024.
//

import Foundation

class BreedDetailsViewModel: ObservableObject {
    @Published var breed: CatBreed?
    
    private let persistenceLoader: PersistenceLoader
    
    init(breed: CatBreed, persistenceLoader: PersistenceLoader) {
        self.breed = breed
        self.persistenceLoader = persistenceLoader
    }
    
    public var name: String {
        breed?.name ?? ""
    }
    
    public var isFavorite: Bool {
        breed?.isFavorite ?? false
    }

    public var origin: String {
        "Origin: \(breed?.origin ?? "")"
    }
    
    public var temperament: String {
        "Temperament: \(breed?.temperament ?? "")"
    }
    
    public var description: String {
        "Description: \(breed?.description ?? "")"
    }   
    
    public var imageURL: URL? {
        URL(string: "https://api.thecatapi.com/v1/images/\(breed?.referenceImageID ?? "")")
    }
    
    public func toggleFavorite() {
        // Apply favorite to breed
        breed?.isFavorite.toggle()
        // Update breed in the DB
        persistenceLoader.saveData(catBreed: breed)
    }
}
