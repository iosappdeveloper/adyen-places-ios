//
//  Place.swift
//  
//
//

import Foundation

struct Place: Decodable {
    let name: String
    let distance: Int   // in meters
    let location: Location?
    let categories: [Category]
}

struct Location: Decodable {
    let formattedAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
    }
}

struct Category: Decodable {
    let name: String
}
