//
//  PickupLocationView.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/6/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class PickupLocationView: UIView {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var delegate: ModalControllerDelegate?
    var viewModel: MapsViewModel?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius =  25
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.masksToBounds = true
        
    }
    
    @IBAction func dismissModal(_ sender: Any) {
//        self.delegate?.removeModalController(controller: )
    }
}
