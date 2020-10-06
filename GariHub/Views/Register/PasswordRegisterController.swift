//
//  PasswordRegisterController.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class PasswordRegisterController: UIViewController {
    
    var viewModel: PasswordRegViewModel?
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
    }
    
    @objc func onTap(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        guard let vm = self.viewModel else { return }
        guard let password = passwordTextField.text else { return }
        
        let request = RegisterRequest(firstName: vm.fullName, lastName: vm.fullName, gender: vm.gender, phoneNumber: vm.phoneNumber, emailAddress: vm.emailAddress, userType: "RIDER", password: password)
        
        vm.provider.request(.register(request: request)) {
            result in
            self.removeSpinner()
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(RegisterResponse.self, from: response.data)
                    self.viewModel?.router.trigger(.login)
                } catch {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Error", message: "Registration failed, please try again later", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true)
                    }
                }
            }
        }
        
    }

}
