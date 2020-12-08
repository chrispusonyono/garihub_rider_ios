//
//  PickupLocationController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/5/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker


class PickupLocationController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    
    var delegate: ModalControllerDelegate?
    
    var viewModel: MapsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.layer.cornerRadius = 25
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.autocompleteClicked(_:)))
        locationLabel.addGestureRecognizer(tap)
        locationLabel.isUserInteractionEnabled = true
        
        startButton.addTarget(self, action: #selector(self.moveToNext(_:)), for: .touchUpInside)
        startButton.layer.cornerRadius = 5
        self.view.layer.cornerRadius = 20
        
    }
    
    @objc func autocompleteClicked(_ sender: UIButton) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // data types to return
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "KE"
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func moveToNext(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            let destination = Destination()
            self.delegate?.parentController.navigationController?.pushViewController(destination, animated: true)
        })
        
        
    }
    
}




extension PickupLocationController: GMSAutocompleteViewControllerDelegate {
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print(">>>>>>>Place name: \(String(describing: place.name))")
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
