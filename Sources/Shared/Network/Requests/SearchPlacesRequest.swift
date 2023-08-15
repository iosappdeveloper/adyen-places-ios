//
//  SearchPlacesRequest.swift
//  Places
//
//

import Foundation
import AdyenNetworking

struct SearchPlacesRequest: Request {
    
    typealias ResponseType = PlacesResponse
    
    typealias ErrorResponseType = EmptyErrorResponse
    
    let method: HTTPMethod = .get
    
    let path: String = "places/search"
    
    var queryParameters: [URLQueryItem] = []
    
    var counter: UInt = 0
    
    var headers: [String : String] = [:]
    
    internal func encode(to encoder: Encoder) throws {}
}
