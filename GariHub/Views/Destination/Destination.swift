//
//  Destination.swift
//  GariHub
//
//  Created by Chrispus Onyono on 05/10/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class Destination: BaseTextFieldController {
    
    var viewModel: DestinationViewModel?
    
    var locationManager:CLLocationManager!


    @IBOutlet weak var currentLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var recentDestinationView: UIView!
    
    @IBOutlet weak var getDestination: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialize()
        getUserCoordinates()
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserCoordinates()
        self.setAppNavigationBar()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(self.dismissView))
    }
    
    @objc
    func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        getDestination.addGestureRecognizer(tapGesture)
        getDestination.isUserInteractionEnabled = true
    }
    
    
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
    // if the tapped view is a UIImageView then set it to imageview
        
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            guard let destination = destinationLocation.text else { return }
            // A hotel in Saigon with an attribution.
            let placeID = destination
            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
              UInt(GMSPlaceField.placeID.rawValue))!
            let placesClient = GMSPlacesClient()

            placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
              (place: GMSPlace?, error: Error?) in
              if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
              }
              if let place = place {
                print("The selected place is: \(String(describing: place.name))")
              }
            })

        }
        
        
    }
    
    
    func getUserCoordinates() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func goBack(sender: UITapGestureRecognizer) {
        guard let vm = self.viewModel else { return }
        vm.router.trigger(.dashboard)
    }
    
    private func initialize(){
        initializeHideKeyboard()
        recentDestinationView.layer.cornerRadius = 20
    }


}


extension Destination: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
            
        
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        
        let position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            
            if error != nil {
                print("Reverse geocode failed: \(String(describing: error?.localizedDescription))")
            } else {
                if let places = response?.results(){
                    if let place = places.first {
                        if let lines = place.lines {
                            self.currentLocation.text = "\(lines[0])"
                        }
                    } else {
                        print("GEOCODE: nil first in places")
                    }
                } else {
                    print("GEOCODE: nil in places")
                }
            }
        }

    }
    

}
