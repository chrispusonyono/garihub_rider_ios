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


class BookRideController: UIViewController {
    
    var viewModel: BookRideViewModel?
    
    @IBOutlet weak var mapsView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrent()

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
        print(userLocation)
        let destinationLocation = CLLocationCoordinate2D(latitude: latitudeNum as! CLLocationDegrees, longitude: longitudeNum as! CLLocationDegrees)
        print(destinationLocation)
        
        getRouteSteps(from: userLocation, to: destinationLocation)

        
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

                //Call this method to draw path on map
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
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapsView // Google MapView


        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: userLocation, coordinate: destinationLocation))
        mapsView.moveCamera(cameraUpdate)
        let currentZoom = mapsView.camera.zoom
        mapsView.animate(toZoom: currentZoom - 1.4)
    }
    
    
 
    
    
    
}
