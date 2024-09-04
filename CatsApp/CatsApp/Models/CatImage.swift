//
//  CatImage.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation

public struct CatImage: Decodable {
    let id: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, url
    }
}
