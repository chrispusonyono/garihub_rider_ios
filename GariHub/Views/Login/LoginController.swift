//
//  LoginController.swift
//  GariHub
//
//  Created by Chrispus Onyono on 30/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class LoginController: UIViewController {
    
    var viewModel: LoginViewModel?

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UILabel!
    @IBOutlet weak var registerButton: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
        signInBtn.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.presentBottomSheet(_:)))
        forgotPasswordBtn.isUserInteractionEnabled = true
        forgotPasswordBtn.addGestureRecognizer(tap)
        
    }
    
    @objc func presentBottomSheet(_ sender: UITapGestureRecognizer) {
        let viewController = ResetPasswordController()
        // Initialize the bottom sheet with the view controller just created
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        // Present the bottom sheet
        present(bottomSheet, animated: true, completion: nil)
    }
    @objc func onTap(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        guard let email = emailAddress.text else { return }
        guard let password = passwordField.text else { return }
        let request = LoginRequest(emailAddress: email, password: password)
        
        provider.request(.login(request: request)) {
            result in
            self.removeSpinner()
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                    self.viewModel?.router.trigger(.dashboard)
                    print(loginResponse)
                } catch {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Error", message: "Login failed", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
    
    
    

}
