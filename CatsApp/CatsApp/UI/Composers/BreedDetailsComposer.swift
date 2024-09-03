//
//  BreedDetailsComposer.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 03/09/2024.
//

import Foundation
import SwiftUI

public final class BreedDetailsComposer {
    
    private init() {}
    
    public static func detailsComposedWith(
        breed: CatBreed,
        persistenceLoader: PersistenceLoader
    ) -> UIHostingController<BreedDetailsView> {
        let viewModel = BreedDetailsViewModel(breed: breed, persistenceLoader: persistenceLoader)
        let breedDetailsView = BreedDetailsView(viewModel: viewModel)
        // Wrap the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: breedDetailsView)
        return hostingController
    }
}
