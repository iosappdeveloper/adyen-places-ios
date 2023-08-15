//
//  ApiContext.swift
//  Places
//
//

import Foundation
import AdyenNetworking

struct Environment: AnyAPIEnvironment {
    var baseURL: URL = URL(string: "https://api.foursquare.com/v3/")!
    
    static let `default`: Environment = Environment()
}

struct PlacesAPIContext: AnyAPIContext {
    let environment: AnyAPIEnvironment = Environment.default
    
    var headers: [String : String] = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "fsq3Stj44bqNJtMTCX7OLHUhivVTEtUiznM5kxtCofG3+bo="
    ]
    
    var queryParameters: [URLQueryItem] = []
}
