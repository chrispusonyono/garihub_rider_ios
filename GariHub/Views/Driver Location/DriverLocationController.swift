//
//  DriverLocationController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/17/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import GoogleMaps
import MaterialComponents.MaterialBottomSheet

class DriverLocationController: BaseTextFieldController {
    
    @IBOutlet var mapView: GMSMapView!
    
    var driverInfo: BookRideResponse?
    let getDriver = DriverInfoController()
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupMaps()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setAppNavigationBar()
    }
    
    func setupViews() {
        
        _ = self.getDriver.view
        getDriver.driverInfo = self.driverInfo
        let data = getDriver.driverInfo
        
        guard let vehicleModel = data?.vehicle.vehicleModel else { return }
        guard let numberPlate = data?.vehicle.regNo else { return }
        guard let firstName = data?.driver.firstName else { return }
        guard let lastName = data?.driver.lastName else { return }
        guard let rating = data?.driver.rating else { return }
        getDriver.carModel.text = vehicleModel
        
        self.navigationItem.title = "Driver location"
        
        getDriver.carNumberPlate.text = numberPlate
        getDriver.driverName.text = ("\(String(describing: firstName))" + " \(String(describing: lastName))")
        getDriver.driverRating.text = "\(String(describing: rating))"
        getDriver.driverArrival.text = ""
        
        
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: getDriver)
        bottomSheet.dismissOnBackgroundTap = false
        bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height / 4)
        present(bottomSheet, animated: true, completion: nil)
        getDriver.delegate = self
        getDriver.calldriverDelegate = self
    }
    
    func setupMaps() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

}

extension DriverLocationController: ModalControllerDelegate {
    func removeModalController(controller: UIViewController) {
        let destination = Destination()
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    var parentController: UIViewController {
        return self
    }
    
    
}


extension DriverLocationController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = ((driverInfo?.vehicle.vehicleLat ?? "") as NSString).doubleValue
        let long = ((driverInfo?.vehicle.vehicleLon ?? "") as NSString).doubleValue
        
        let position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        
        let marker = GMSMarker(position: position)
        marker.title = "Driver Location"
        marker.icon = UIImage(named: "car")
        marker.tracksViewChanges = true
        marker.map = mapView
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        let circleCenter = position
        let circ = GMSCircle(position: circleCenter, radius: 5000)
        
        circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circ.strokeColor = UIColor.red
        circ.strokeWidth = 1
        
        let update = GMSCameraUpdate.fit(circ.bounds())
        mapView.animate(with: update)
        
    }
}

extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(_ positive : Bool) -> CLLocationCoordinate2D {
            let sign: Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180 / .pi)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * .pi / 180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(true),
                                   coordinate: locationMinMax(false))
    }
}
