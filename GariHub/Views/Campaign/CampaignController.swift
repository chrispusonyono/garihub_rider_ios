//
//  CampaignController.swift
//  GariHub
//
//  Created by Chrispus Onyono on 23/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class CampaignController: UIViewController {

    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        skipButton.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
    }
    
    @objc func onTap(_ sender: UIButton) {
        let campaignTwo = CampaignTwo()
        campaignTwo.modalPresentationStyle = .fullScreen
        self.present(campaignTwo, animated: true, completion: nil)
        
    }


}
