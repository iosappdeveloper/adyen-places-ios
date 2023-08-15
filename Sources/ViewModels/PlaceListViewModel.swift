//
//  PlaceListViewModel.swift
//  PlacesUIKit
//
//  Created by Matoria, Ashok on 8/13/23.
//

import Foundation
import AdyenNetworking
import Combine
import CoreLocation

final class PlaceListViewModel {
    private let apiClient: APIClient
    private let geoCoder: CLGeocoder
    @Published var places = [Place]()
    @Published var error: Error?
    
    init(apiClient: APIClient = APIClient(apiContext: PlacesAPIContext()), geoCoder: CLGeocoder = CLGeocoder()) {
        self.apiClient = apiClient
        self.geoCoder = geoCoder
    }
    
    @objc func fetchPlaces() {
        var searchRequest = SearchPlacesRequest()
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "radius", value: UserPreference.searchRadiusInMeters),
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "sort", value: UserPreference.sortBy.queryItemValue)
        ]
        searchRequest.queryParameters.append(contentsOf: queryItems)
        if let coordinate = UserPreference.currentLocation?.coordinate {
            searchRequest.queryParameters.append(
                URLQueryItem(name: "ll", value: "\(coordinate.latitude),\(coordinate.longitude)")
            )
        }
        
        apiClient.perform(searchRequest) { [weak self] result in
            guard let self = self else { return }
            assert(Thread.current == .main, "API callback expected on main thread")
            
            switch result {
            case .success(let response):
                self.error = nil
                // Sort to show nearest result first
                self.places = response.results.sorted(by: \.distance)
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func mapsURL(for indexPath: IndexPath, completionHandler: @escaping(URL) -> Void) {
        guard let address = places[indexPath.row].location?.formattedAddress else { return }
        geoCoder.geocodeAddressString(address) { placeMarks, _ in
            if let coordinate = placeMarks?.first?.location?.coordinate, let url = URL(string: "maps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)") {
                completionHandler(url)
            }
        }
    }
    
    var retryButtonTitle: String {
        NSLocalizedString("Retry", comment: "button title to refetch server data")
    }
    
    var cancelButtonTitle: String {
        NSLocalizedString("Cancel", comment: "button title to cancel an alert")
    }
    
    var screenTitle: String {
        NSLocalizedString("Popular Nearby Places", comment: "screen title")
    }
}

private extension Sort {
    var queryItemValue: String {
        String(describing: self).uppercased()
    }
}
