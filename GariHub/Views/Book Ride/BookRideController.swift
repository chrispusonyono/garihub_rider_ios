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
import CoreLocation
import MaterialComponents.MaterialBottomSheet


class BookRideController: BaseTextFieldController {
    
    var viewModel: BookRideViewModel?
    
    let selectVehicle = SelectVehicleController()
    let getDriver = DriverInfoController()
    var delegate: ModalControllerDelegate?
    
    var driverInfo: BookRideResponse?


    
    @IBOutlet weak var mapsView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrent()
        setupViews()
    }
    
    func getCurrent() {
        
        let userLoc = UserDefaults.standard.dictionary(forKey: "currentLocation")
        let destination = UserDefaults.standard.dictionary(forKey: "destinationLocation")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let latitude = userLoc?["lat"]
        let latNum = formatter.number(from: latitude as! String)
        
        let longitude = userLoc?["long"]
        let longNum = formatter.number(from: longitude as! String)
        let lat = destination?["lat"]
        let latitudeNum = formatter.number(from: lat as! String)
        let long = destination?["long"]
        let longitudeNum = formatter.number(from: long as! String)
        
        let userLocation = CLLocationCoordinate2D(latitude: latNum as! CLLocationDegrees , longitude: longNum as! CLLocationDegrees)
        let destinationLocation = CLLocationCoordinate2D(latitude: latitudeNum as! CLLocationDegrees, longitude: longitudeNum as! CLLocationDegrees)
        getRouteSteps(from: userLocation, to: destinationLocation)
    }
    
    func setupViews() {
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: selectVehicle)
        bottomSheet.dismissOnBackgroundTap = false
        bottomSheet.dismissOnDraggingDownSheet = true
        present(bottomSheet, animated: true, completion: nil)
        selectVehicle.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setAppNavigationBar()
        self.navigationItem.backBarButtonItem = self.navigationItemFactory(action: #selector(self.backButtonTapped(_:)), image: UIImage(named: "left-arrow"))
    }
    
    @objc private func backButtonTapped(_ sender: UIBarButtonItem) {
        guard let vm = self.viewModel else { return }
        vm.router.trigger(.destination)

    }
    
    private func navigationItemFactory(action: Selector, image: UIImage?) -> UIBarButtonItem {
    let button = UIButton(type: .custom)
    button.addTarget(self, action: action, for: .touchUpInside)
    button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    button.imageView?.contentMode = .center
    button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    
    return UIBarButtonItem(customView: button)
    }
    
    func getRouteSteps(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(API_KEY)")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            guard let routes = jsonResult["routes"] as? [Any] else {
                return
            }
            guard let route = routes[0] as? [String: Any] else {
                return
            }
            guard let legs = route["legs"] as? [Any] else {
                return
            }
            guard let leg = legs[0] as? [String: Any] else {
                return
            }
            guard let steps = leg["steps"] as? [Any] else {
                return
            }
            for item in steps {
                guard let step = item as? [String: Any] else {
                    return
                }
                guard let polyline = step["polyline"] as? [String: Any] else {
                    return
                }
                guard let polyLineString = polyline["points"] as? String else {
                    return
                }
                DispatchQueue.main.async {
                    self.drawPath(from: polyLineString)
                }
            }
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        
        let userLoc = UserDefaults.standard.dictionary(forKey: "currentLocation")
        let destination = UserDefaults.standard.dictionary(forKey: "destinationLocation")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let latitude = userLoc?["lat"]
        let latNum = formatter.number(from: latitude as! String)
        
        let longitude = userLoc?["long"]
        let longNum = formatter.number(from: longitude as! String)
        let lat = destination?["lat"]
        let latitudeNum = formatter.number(from: lat as! String)
        let long = destination?["long"]
        let longitudeNum = formatter.number(from: long as! String)
        
        let userLocation = CLLocationCoordinate2D(latitude: latNum as! CLLocationDegrees , longitude: longNum as! CLLocationDegrees)
        let destinationLocation = CLLocationCoordinate2D(latitude: latitudeNum as! CLLocationDegrees, longitude: longitudeNum as! CLLocationDegrees)
        let currentLocMarker = GMSMarker(position: userLocation)
        currentLocMarker.title = "Your Location"
        let destinationLocMarker = GMSMarker(position: destinationLocation)
        destinationLocMarker.title = "Destination"
        
        
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = UIColor.black
        polyline.map = mapsView // Google MapView
        
        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: userLocation, coordinate: destinationLocation))
        mapsView.moveCamera(cameraUpdate)
        let currentZoom = mapsView.camera.zoom
        mapsView.animate(toZoom: currentZoom)
    }
    
}


extension BookRideController: ModalControllerDelegate {
    func removeModalController(controller: UIViewController) {
        let driverLocation = DriverLocationController()
        self.navigationController?.pushViewController(driverLocation, animated: true)
    }
    
    var parentController: UIViewController {
        return self
    }
    
    
}
