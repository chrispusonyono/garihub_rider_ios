//
//  CampaignThree.swift
//  GariHub
//
//  Created by Chrispus Onyono on 25/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class CampaignThree: UIViewController {

    
    @IBOutlet weak var skipButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
    }
    @objc func onTap(_ sender: UIButton) {
          let register = RegistrationController()
        register.modalPresentationStyle = .fullScreen
        self.present(register, animated: true, completion: nil)
          
      }

}
