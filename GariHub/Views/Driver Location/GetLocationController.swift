//
//  GetLocationController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/17/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit


class GetLocationController: UIViewController {
    
    @IBOutlet weak var cancelRideBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate: ModalControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        cancelRideBtn.layer.cornerRadius = 5
        cancelRideBtn.addTarget(self, action: #selector(self.moveToNext(_:)), for: .touchUpInside)

    }
    
    @objc func moveToNext(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            let destination = Destination()
            self.delegate?.parentController.navigationController?.pushViewController(destination, animated: true)
        })
    }

}
