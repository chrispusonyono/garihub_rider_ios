//
//  MapsController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/4/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapsController: UIViewController {
    
    var viewModel: MapsViewModel?
    
    @IBOutlet weak var mapsView: GMSMapView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Address"
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        subView.frame = subView.frame.inset(by: UIEdgeInsets(top: 40, left: .zero, bottom: .zero, right: .zero))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.hidesNavigationBarDuringPresentation = false

        definesPresentationContext = true
        
        
    }
    
    func setupMaps(){
        
    }
    

}

extension MapsController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        guard let vm = self.viewModel else { return }
        searchController?.isActive = false
        print("Place Address: \(String(describing: place.formattedAddress))")
        
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            vm.router.trigger(.destination)
        }
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
