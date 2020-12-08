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

class DriverLocationController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    let getDriver = DriverInfoController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: getDriver)
        bottomSheet.dismissOnBackgroundTap = false
        present(bottomSheet, animated: true, completion: nil)
        getDriver.delegate = self
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
