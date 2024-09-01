//
//  CatImage.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation

struct CatImage: Decodable {
    let id: String
    let width, height: Int
    let url: String
}
