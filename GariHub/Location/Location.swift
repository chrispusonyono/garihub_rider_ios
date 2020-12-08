//
//  Location.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/8/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    
    var didChangeStatus: ((Bool) -> Void)?

    
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
}

// MARK: - Core Location Delegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .authorizedAlways:
            print("authorizedAlways")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        @unknown default:
            fatalError()
        }
    }
}


