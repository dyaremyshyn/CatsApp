//
//  CatBreed.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation

public struct CatBreed: Decodable {
    let weight: Weight
    let id, name: String
    let cfaURL: String?
    let vetstreetURL: String
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String
    let description, lifeSpan: String
    let indoor, lap: Int?
    let altNames: String
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int
    let energyLevel, grooming, healthIssues, intelligence: Int
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int
    let experimental, hairless, natural, rare, rex: Int
    let suppressedTail, shortLegs: Int
    let wikipediaURL: String
    let hypoallergenic: Int
    let referenceImageID: String
    let image: CatImage

    enum CodingKeys: String, CodingKey {
        case weight, id, name
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case description
        case lifeSpan = "life_span"
        case indoor, lap
        case altNames = "alt_names"
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation
        case experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
        case referenceImageID = "reference_image_id"
        case image
    }
}
