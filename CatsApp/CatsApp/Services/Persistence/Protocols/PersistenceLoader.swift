//
//  PersistenceLoader.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 02/09/2024.
//

import Foundation

public protocol PersistenceLoader {
    func getData() -> BreedsResponse
    func saveData(catBreed: CatBreed?)
}
