//
//  BreedDetailsView.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 03/09/2024.
//

import SwiftUI

public struct BreedDetailsView: View {
    @ObservedObject var viewModel: BreedDetailsViewModel
        
    public var body: some View {
        ScrollView {
            Section(content: {
                VStack(content: {
                    if let imageURL = viewModel.imageURL {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                        } placeholder: {
                            Image(systemName: "cat")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                        }
                        .padding([.leading, .trailing], 16)
                    }
                    else {
                        Image(systemName: "cat")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    }
                })
                VStack(alignment:.leading, spacing: 10) {
                    Text(viewModel.origin)
                        .font(.subheadline)
                    Text(viewModel.temperament)
                        .font(.subheadline)
                    Text(viewModel.description)
                        .font(.subheadline)
                }
                .padding([.leading, .trailing], 16)
            }, header: {
                HStack {
                    Text(viewModel.name)
                        .font(.headline)
                        .padding([.top, .leading])

                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleFavorite()
                    }) {
                        Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                            .padding([.top, .trailing])
                            .tint(.yellow)
                    }
                }
            })
        }
        
    }
}

#Preview {
    BreedDetailsView(viewModel: BreedDetailsViewModel(breed: CatBreed(id: "", name: "Bolinha", temperament: "Moderate", origin: "Street", description: "Meaow", lifeSpan: "10-12", referenceImageID: "0XYvRd7oD", image: CatImage(id: "0XYvRd7oD", url: ""), isFavorite: false), persistenceLoader: PersistenceService()))
}
