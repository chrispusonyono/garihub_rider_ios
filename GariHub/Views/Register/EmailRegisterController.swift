//
//  EmailRegisterController.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class EmailRegisterController: BaseTextFieldController {
    
    var viewModel: EmailRegViewModel?

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
        setTransparentNavigationBar()
    }
    
    @objc func onTap(_ sender: UIButton) {
        
        guard let email = emailAddress.text else { return }
        guard let vm = self.viewModel else { return }
        
        self.viewModel?.router.trigger(.passReg(phoneNumber: vm.phoneNumber, fullName: vm.fullName, gender: vm.gender, email: email))
    }


}
