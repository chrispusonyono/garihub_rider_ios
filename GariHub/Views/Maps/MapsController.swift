//
//  MapsController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/4/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import MaterialComponents.MaterialBottomSheet


class MapsController: UIViewController {
    
    var viewModel: MapsViewModel?
    var locationManager: CLLocationManager!
    let locationVC = PickupLocationController()
    var delegate: ModalControllerDelegate?
    let pickupLocationView: PickupLocationView = .fromNib(nibName: PickupLocationView.className)
    
    @IBOutlet weak var mapsView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMaps()
        setupViews()
        
    }
    
    func setupModal() {
        pickupLocationView.delegate = delegate
        pickupLocationView.viewModel = viewModel
        pickupLocationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickupLocationView)
        
        NSLayoutConstraint.activate([
            pickupLocationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pickupLocationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            pickupLocationView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            pickupLocationView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    func setupMaps(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupViews() {
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: locationVC)
        bottomSheet.dismissOnBackgroundTap = false
        present(bottomSheet, animated: true, completion: nil)
        locationVC.delegate = self
    }
    
}

extension MapsController: ModalControllerDelegate {
    
    var parentController: UIViewController {
           return self
       }
    
    func removeModalController(controller: UIViewController) {
        let destination = Destination()
        self.navigationController?.pushViewController(destination, animated: true)
    }
}

extension MapsController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place ID \(String(describing: place.placeID))")
        print("Place attributions \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension MapsController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 5.0, animations: { () -> Void in
        })
    }
}

extension MapsController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        
        let position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        
        let marker = GMSMarker(position: position)
        marker.title = "Your location"
        marker.tracksViewChanges = true
        marker.map = mapsView
        
        
        if mapsView.isHidden {
            mapsView.isHidden = false
            mapsView.camera = camera
        } else {
            mapsView.animate(to: camera)
        }
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            
            if error != nil {
                print("Reverse geocode failed: \(String(describing: error?.localizedDescription))")
            } else {
                if let places = response?.results(){
                    if let place = places.first {
                        if let lines = place.lines {
                            print("\(lines[0])")
                            self.locationVC.locationLabel.text = lines[0]
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
