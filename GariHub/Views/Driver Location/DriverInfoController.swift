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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
        callBtn.addTarget(self, action: #selector(self.callDriver(_:)), for: .touchUpInside)
    }
    
    
    @objc func callDriver(_ sender: UIButton) {
        self.calldriverDelegate?.callDriver()
    }
    
    func setupViews() {
        messageBtn.layer.cornerRadius = 10
        callBtn.layer.cornerRadius = 20
        callBtn.layer.borderWidth = 1
        callBtn.layer.borderColor = UIColor.hex("fbcb00").cgColor
        self.view.layer.cornerRadius = 20
        
    }

}
