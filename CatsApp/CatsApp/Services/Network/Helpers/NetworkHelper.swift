//
//  NetworkHelper.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import Foundation

struct NetworkHelper {
    
    private static var baseUrl: String {
        "https://api.thecatapi.com"
    }
    
    public static var breeds: String {
        baseUrl + "/v1/breeds"
    }
    
    public static var images: String {
        baseUrl + "/v1/images/"
    }
    
    public static var apiKey: String {
        "?api_key=live_XkPUYswV8ujjoPFiSCBARlvWWEIPfWdO9aPJ3PnXO8l78KYzQMM2kOGfqekLiKdA"
    }
}
