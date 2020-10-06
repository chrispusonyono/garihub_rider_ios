//
//  RegistrationTwoController.swift
//  GariHub
//
//  Created by Chrispus Onyono on 02/10/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class RegistrationTwoController: UIViewController {
    
    var viewModel: RegTwoViewModel?
    var genderStatus = "MALE"
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var noGenderCheckBox: UIView!
    @IBOutlet weak var btnBox: UIButton!
    @IBOutlet weak var submitButon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButon.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
    }
    
    @IBAction func selectGender(_ sender: UISegmentedControl) {
        switch gender.selectedSegmentIndex {
        case 0:
            genderStatus = "MALE"
        case 1:
            genderStatus = "FEMALE"
        default:
            break
            }
    }
    @IBAction func noGender(_ sender: UIButton) {
        if (btnBox.isSelected == true) {
            btnBox.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
        }
        
    }
    @objc func onTap(_ sender: UIButton) {
        
        guard let vm = self.viewModel else { return }
        guard let fullnames = fullNameTextField.text else { return }
        vm.router.trigger(.emailReg(phoneNumber: vm.phoneNumber, fullName: fullnames, gender: genderStatus))

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
