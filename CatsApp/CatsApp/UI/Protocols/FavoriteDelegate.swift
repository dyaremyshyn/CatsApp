//
//  FavoriteDelegate.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation

protocol FavoriteDelegate: AnyObject  {
    func toggleFavorite(breed: CatBreed)
}
