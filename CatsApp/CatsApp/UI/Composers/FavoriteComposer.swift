//
//  FavoriteComposer.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 02/09/2024.
//

import UIKit

public final class FavoriteComposer {
    
    private init() {}
    
    public static func favoriteComposedWith(
        persistenceLoader: PersistenceLoader,
        selection: @escaping (CatBreed) -> Void = { _  in }
    ) -> FavoritesViewController {
        let viewModel = FavoritesViewModel(persistenceLoader: persistenceLoader, selection: selection)
        let viewController = FavoritesViewController.makeWith(viewModel: viewModel)
        return viewController
    }
}

extension FavoritesViewController {
    static func makeWith(viewModel: FavoritesViewModel) -> FavoritesViewController {
        let viewController = FavoritesViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
