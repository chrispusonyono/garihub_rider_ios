//
//  BookRideController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/5/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class BookRideController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func fetchRoute(from route: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
//        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
//
    }

}
