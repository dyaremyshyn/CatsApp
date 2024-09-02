//
//  CatBreed.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation

public struct CatBreed: Decodable, Hashable {
    let weight: Weight?
    let id, name: String
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String?
    let description, lifeSpan: String?
    let indoor, lap: Int?
    let altNames: String?
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int?
    let energyLevel, grooming, healthIssues, intelligence: Int?
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int?
    let experimental, hairless, natural, rare, rex: Int?
    let suppressedTail, shortLegs: Int?
    let wikipediaURL: String?
    let hypoallergenic: Int?
    let referenceImageID: String?
    let image: CatImage?
    var isFavorite: Bool = false

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
    
    public static func == (lhs: CatBreed, rhs: CatBreed) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(weight: Weight? = nil, id: String, name: String, cfaURL: String? = nil, vetstreetURL: String? = nil, vcahospitalsURL: String? = nil, temperament: String?, origin: String?, countryCodes: String? = nil, countryCode: String? = nil, description: String?, lifeSpan: String?, indoor: Int? = nil, lap: Int? = nil, altNames: String? = nil, adaptability: Int? = nil, affectionLevel: Int? = nil, childFriendly: Int? = nil, dogFriendly: Int? = nil, energyLevel: Int? = nil, grooming: Int? = nil, healthIssues: Int? = nil, intelligence: Int? = nil, sheddingLevel: Int? = nil, socialNeeds: Int? = nil, strangerFriendly: Int? = nil, vocalisation: Int? = nil, experimental: Int? = nil, hairless: Int? = nil, natural: Int? = nil, rare: Int? = nil, rex: Int? = nil, suppressedTail: Int? = nil, shortLegs: Int? = nil, wikipediaURL: String? = nil, hypoallergenic: Int? = nil, referenceImageID: String?, image: CatImage? = nil, isFavorite: Bool) {
        self.weight = weight
        self.id = id
        self.name = name
        self.cfaURL = cfaURL
        self.vetstreetURL = vetstreetURL
        self.vcahospitalsURL = vcahospitalsURL
        self.temperament = temperament
        self.origin = origin
        self.countryCodes = countryCodes
        self.countryCode = countryCode
        self.description = description
        self.lifeSpan = lifeSpan
        self.indoor = indoor
        self.lap = lap
        self.altNames = altNames
        self.adaptability = adaptability
        self.affectionLevel = affectionLevel
        self.childFriendly = childFriendly
        self.dogFriendly = dogFriendly
        self.energyLevel = energyLevel
        self.grooming = grooming
        self.healthIssues = healthIssues
        self.intelligence = intelligence
        self.sheddingLevel = sheddingLevel
        self.socialNeeds = socialNeeds
        self.strangerFriendly = strangerFriendly
        self.vocalisation = vocalisation
        self.experimental = experimental
        self.hairless = hairless
        self.natural = natural
        self.rare = rare
        self.rex = rex
        self.suppressedTail = suppressedTail
        self.shortLegs = shortLegs
        self.wikipediaURL = wikipediaURL
        self.hypoallergenic = hypoallergenic
        self.referenceImageID = referenceImageID
        self.image = image
        self.isFavorite = isFavorite
    }

    public static func map(cat: BreedEntity) -> CatBreed {
        CatBreed(
            id: cat.id ?? "",
            name: cat.name ?? "",
            temperament: cat.temperament,
            origin: cat.origin,
            description: cat.descriptionBreed,
            lifeSpan: cat.lifeSpan,
            referenceImageID: cat.image,
            isFavorite: cat.isFavorite
        )
    }
}
