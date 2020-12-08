//
//  RegistrationController.swift
//  GariHub
//
//  Created by Chrispus Onyono on 23/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import Moya

let provider = MoyaProvider<AuthTarget>()
let rProvider = MoyaProvider<RidesTarget>()


class RegistrationController: BaseTextFieldController {
    
    var viewModel: RegistrationViewModel?
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var loginButton: UILabel!
    @IBOutlet weak var activateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        activateButton.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
        setupViews()
        setTransparentNavigationBar()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.loginFunction(sender:)))
        loginButton.isUserInteractionEnabled = true
        loginButton.addGestureRecognizer(tap)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @objc func loginFunction(sender: UITapGestureRecognizer) {
        self.viewModel?.router.trigger(.login)
    }
    
    func validations() {
        if phoneNumber.text == "" {
            self.showAlert(withTitle: "Phone number", withMessage: "Phone number cannot be blank")
        }
    }
    
    
    @objc func onTap(_ sender: UIButton) {
        validations()
        self.showSpinner(onView: self.view)
//        guard let vm = self.viewModel else { return }
        
        guard let phone = phoneNumber.text else { return }
        
        provider.request(.validatePhone(phoneNumber: phone)) {
            result in
            self.removeSpinner()
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let response):
                    do {
                        let otpResponse = try JSONDecoder().decode(OTPResponse.self, from: response.data)
                        print(otpResponse)
                        self.viewModel?.router.trigger(.otp(phoneNumber: phone))
                    } catch {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Error", message: "OTP was not sent", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
        }
        
    }
    
    

}
