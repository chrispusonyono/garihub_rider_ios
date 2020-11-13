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
    var resultsViewController: GMSAutocompleteViewController?
    
    
    var locationManager:CLLocationManager!
    
    
    @IBOutlet weak var currentLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var recentDestinationView: UIView!
    
    @IBOutlet weak var stopview: UIView!
    @IBOutlet weak var stopStack: UIStackView!
    @IBOutlet weak var stopPoint: UITextField!
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.autocompleteClicked(_:)))
        stopPoint.addGestureRecognizer(tapGesture)
        stopPoint.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.autocompleteClicked(_:)))
        destinationLocation.addGestureRecognizer(tap)
        destinationLocation.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        getDestination.addGestureRecognizer(imageTap)
        getDestination.isUserInteractionEnabled = true
        resultsViewController?.delegate = self
        resultsViewController = GMSAutocompleteViewController()
        
    }
    
    @objc func autocompleteClicked(_ sender: UITapGestureRecognizer) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // data types to return
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue))!
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "KE"
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        stopview.isHidden = false
        stopStack.isHidden = false
        

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

extension Destination: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place ID \(String(describing: place.placeID))")
        print("Place attributions \(String(describing: place.attributions))")

        let lat = place.coordinate.latitude
        print("dest lat\(lat)")
        let long = place.coordinate.longitude
        print("dest long\(long)")
        
        var latitude = ""
        var longitude = ""
        
        latitude = String(lat)
        longitude = String(long)
        
        let locationDict = ["lat": latitude, "long": longitude]
        
        UserDefaults.standard.set(locationDict, forKey: "destinationLocation")
        
        self.destinationLocation.text = place.name
        DispatchQueue.main.async {
            self.stopPoint.text = place.name
        }
        dismiss(animated: true, completion: {
            let bookRide = BookRideController()
            self.navigationController?.pushViewController(bookRide, animated: true)
        })
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Was cancelled")
        dismiss(animated: true, completion: nil)
        
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
}


extension Destination: CLLocationManagerDelegate {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        var myLocation = ""
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        
        
        let position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        var latitude = ""
        var longitude = ""
        
        latitude = String(position.latitude)
        longitude = String(position.longitude)
        
        let locationDict = ["lat": latitude, "long": longitude]
        print(locationDict)
        UserDefaults.standard.set(locationDict, forKey: "currentLocation")
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            
            if error != nil {
                print("Reverse geocode failed: \(String(describing: error?.localizedDescription))")
            } else {
                if let places = response?.results(){
                    if let place = places.first {
                        if let lines = place.lines {
                            myLocation = "\(lines[0])"
                            self.currentLocation.text = myLocation
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
