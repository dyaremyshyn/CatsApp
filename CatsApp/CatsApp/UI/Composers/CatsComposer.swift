//
//  CatsComposer.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation

public final class CatsComposer {
    
    private init() {}
    
    public static func catsComposedWith(
        client: HTTPClient,
        breedsLoader: BreedsDataLoader,
        persistenceLoader: PersistenceLoader,
        selection: @escaping (CatBreed) -> Void = { _  in }
    ) -> CatsViewController {
        let viewModel = CatsViewModel(client: client, breedsLoader: breedsLoader, persistenceLoader: persistenceLoader, selection: selection)
        let viewController = CatsViewController.makeWith(viewModel: viewModel)
        return viewController
    }
}

extension CatsViewController {
    static func makeWith(viewModel: CatsViewModel) -> CatsViewController {
        let viewController = CatsViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
