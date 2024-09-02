//
//  PersistenceService.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 02/09/2024.
//

import Foundation
import CoreData

struct PersistenceService: PersistenceLoader {
    
    private static let modelName = "CatsApp"
    private static let entity = "BreedEntity"

    private let container: NSPersistentContainer
    
    public init() {
        container = NSPersistentContainer(name: PersistenceService.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public func getData() -> BreedsResponse {
        var data: BreedsResponse = []
        
        let request = NSFetchRequest<BreedEntity>(entityName: PersistenceService.entity)
        
        do {
            let result = try container.viewContext.fetch(request)
            data =  result.map { CatBreed.map(cat: $0 ) }
        } catch {
            print(error.localizedDescription)
        }
        
        return data
    }
    
    public func saveData(catBreed: CatBreed?) {
        // Verify if catBreed is not nil
        guard let catBreed = catBreed else { return }
        
        // Check if breed exists
        let request = NSFetchRequest<BreedEntity>(entityName: PersistenceService.entity)
        request.predicate = NSPredicate(format: "id == %@", catBreed.id as CVarArg)
        
        do {
            let result = try container.viewContext.fetch(request)
            
            guard let editCat = result.first else {
                print("Breed entity not found with id: \(catBreed.id)")
                
                let newEntry = BreedEntity(context: container.viewContext)
                newEntry.id = catBreed.id
                newEntry.name = catBreed.name
                newEntry.descriptionBreed = catBreed.description
                newEntry.origin = catBreed.origin
                newEntry.temperament = catBreed.temperament
                newEntry.lifeSpan = catBreed.lifeSpan
                newEntry.image = catBreed.referenceImageID
                newEntry.isFavorite = catBreed.isFavorite
                
                self.saveData()
                
                return
            }
            
            // Modify the properties of the fetched breed, in this case, we only will modify 'isFavorite'
            editCat.isFavorite = catBreed.isFavorite
            
            self.saveData()
            
            print("Breed entity with id \(catBreed.id) edited successfully")
            
        } catch {
            print("Error editing breed entity: \(error)")
        }
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
