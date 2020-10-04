//
//  EmailRegisterController.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class EmailRegisterController: UIViewController {
    
    var viewModel: EmailRegViewModel?

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
    }
    
    @objc func onTap(_ sender: UIButton) {
        
        guard let email = emailAddress.text else { return }
        guard let vm = self.viewModel else { return }
        
        self.viewModel?.router.trigger(.passReg(phoneNumber: vm.phoneNumber, fullName: vm.fullName, gender: vm.gender, email: email))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

}
