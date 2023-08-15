//
//  UserFormatter.swift
//  PlacesUIKit
//
//  Created by Matoria, Ashok on 8/13/23.
//

import Foundation
import CoreLocation

struct UserFormatter {
    /// Converts and formats the given distance for display purpose based on user's preference
    /// - Parameters:
    ///   - meters: distance in meters
    ///   - unitStyle: suffixed unit style e.g. mi or miles. Defaults to .medium
    /// - Returns: Formatted String
    static func stringForDistance(meters: Int, unitStyle: Formatter.UnitStyle = .medium) -> String {
        let convertedMeasurement = Measurement(value: Double(meters), unit: UnitLength.meters).converted(to: UserPreference.length)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.numberFormatter.maximumFractionDigits = 1
        
        return formatter.string(from: convertedMeasurement)
    }
}

struct UserPreference {
    static let length: UnitLength = .miles
    static var defaultSearchRadius = 5
    static var currentLocation: CLLocation?
    static let sortBy: Sort = .popularity
    
    static var searchRadiusInMeters: String {
        String(Int(Measurement(value: Double(Self.defaultSearchRadius), unit: UserPreference.length).converted(to: .meters).value.rounded()))
    }
}

enum Sort {
    case relevance, rating, distance, popularity
}
