//
//  DriverInfoController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/17/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class DriverInfoController: UIViewController {
    
    var delegate: ModalControllerDelegate?
    var driverInfo: BookRideResponse?
    var calldriverDelegate: CallDriverDelegate?

    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverRating: UILabel!
    @IBOutlet weak var driverArrival: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carNumberPlate: UILabel!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var cancelRide: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
        callBtn.addTarget(self, action: #selector(self.callDriver(_:)), for: .touchUpInside)
        cancelRide.addTarget(self, action: #selector(self.cancelRide(_:)), for: .touchUpInside)
    }
    
    func makeCall() {
        guard let driverNumber = self.driverInfo?.driver.phoneNumber else { return }
        
        if let url = URL(string: "tel://\(driverNumber)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                   } else {
                       UIApplication.shared.openURL(url)
                   }
        } else {
           print("Unable to make phone call")
        }

    }
    
    
    @objc func callDriver(_ sender: UIButton) {
        guard let driverNumber = self.driverInfo?.driver.phoneNumber else { return }
        
        let phoneAction = UIAlertController(title: nil, message: "Call", preferredStyle: .actionSheet)
        
        let phone = UIAlertAction(title: driverNumber, style: .default, handler: {
            (action) in
            self.makeCall()
        })
        
        phoneAction.addAction(phone)
        
        self.present(phoneAction, animated: true, completion: nil)
        
    }
    
    @objc func cancelRide(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        messageBtn.layer.cornerRadius = 10
        callBtn.layer.cornerRadius = 20
        callBtn.layer.borderWidth = 1
        callBtn.layer.borderColor = UIColor.hex("fbcb00").cgColor
        self.view.layer.cornerRadius = 20
        
    }

}
