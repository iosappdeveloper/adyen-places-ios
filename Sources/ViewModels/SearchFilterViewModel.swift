//
//  SearchFilterViewModel.swift
//  PlacesUIKit
//
//  Created by Matoria, Ashok on 8/14/23.
//

import Foundation
import CoreLocation

final class SearchFilterViewModel: NSObject {
    private var locationManager: CLLocationManager
    private var currentLocation: CLLocation?
    private(set) var currentRadius: Int
    private var triggerRefetchBlock: (() -> Void)
    var refreshUI: (() -> Void)?
    
    init(locationManager: CLLocationManager = CLLocationManager(), currentLocation: CLLocation? = UserPreference.currentLocation, currentRadius: Int = UserPreference.defaultSearchRadius, triggerRefetchBlock: @escaping (() -> Void)) {
        self.locationManager = locationManager
        self.currentLocation = currentLocation
        self.currentRadius = currentRadius
        self.triggerRefetchBlock = triggerRefetchBlock
    }
    
    var showCurrentLocationCheck: Bool {
        currentLocation != nil
    }
    
    func checkAndTriggerRefetch() {
        var shouldRefreshData = false
        if let newLocation = currentLocation {
            if let oldLocation = UserPreference.currentLocation {
                shouldRefreshData = abs(oldLocation.distance(from: newLocation)) > 20   // distance threshold
            } else {
                shouldRefreshData = true
            }
        }
        
        shouldRefreshData = shouldRefreshData || currentRadius != UserPreference.defaultSearchRadius
        
        if shouldRefreshData {
            UserPreference.currentLocation = currentLocation
            UserPreference.defaultSearchRadius = currentRadius
            triggerRefetchBlock()
        }
    }
    
    func handleLocationAuthorizationStatus() {
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .denied:
            let title = NSLocalizedString("Access Denied", comment: "alert title")
            let message = NSLocalizedString("Please check 'Settings' app and enable location access to get more accurate nearby places.", comment: "alert title")
            UIUtils.showAlert(title: title, message: message, okAction: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locationManager.location {
                currentLocation = location
            }
            locationManager.startUpdatingLocation()
        case .restricted:
            let title = NSLocalizedString("Access Restricted", comment: "alert title")
            let message = NSLocalizedString("The location access for this app is restricted. You might need to check with this device administrator or supervisor.", comment: "alert title")
            UIUtils.showAlert(title: title, message: message, okAction: nil)
        @unknown default:
            assertionFailure("Unknown authorizationStatus case, you might have to handle this unexpected case.")
        }
    }
    
    func update(currentRadius: Int) {
        self.currentRadius = currentRadius
    }
    
    var screenTitle: String {
        NSLocalizedString("Search Criteria", comment: "screen title")
    }
}

extension SearchFilterViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if (locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways) {
            if let location = locationManager.location {
                currentLocation = location
            }
            locationManager.startUpdatingLocation()
        }
        refreshUI?()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastCoordinate = locations.last?.coordinate, let currentCoordinate = currentLocation?.coordinate, lastCoordinate.latitude != currentCoordinate.latitude, lastCoordinate.longitude != currentCoordinate.longitude else {
            return
        }
        currentLocation = locations.last
        refreshUI?()
    }
}
