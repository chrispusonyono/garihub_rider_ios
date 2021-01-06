//
//  LoginController.swift
//  GariHub
//
//  Created by Chrispus Onyono on 30/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class LoginController: BaseTextFieldController {
    
    var viewModel: LoginViewModel?

    @IBOutlet weak var noUserError: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var passwordImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        setupViews()
        setTransparentNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
        signInBtn.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.presentBottomSheet(_:)))
        forgotPasswordBtn.isUserInteractionEnabled = true
        forgotPasswordBtn.addGestureRecognizer(tap)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.togglePasswordTapped(_:)))
        passwordImage.isUserInteractionEnabled = true
        passwordImage.addGestureRecognizer(tapImage)
        
        registerButton.addTarget(self, action: #selector(self.goToRegister(_:)), for: .touchUpInside)
        noUserError.text = ""
        signInBtn.layer.cornerRadius = 5
        signInBtn.clipsToBounds = true
        
        let regularString = NSMutableAttributedString(string: "I don't have an account!",
        attributes: regularAttributes)
        
        regularString.append(NSAttributedString(string: " Register", attributes: boldGreenAttributes))
        
        registerButton.setAttributedTitle(regularString, for: .normal)
        
    }
    
    @objc func goToRegister(_ sender: UIButton) {
        self.viewModel?.router.trigger(.validatePhone)
        print("styff")
    }

    
    @objc func togglePasswordTapped(_ sender: UITapGestureRecognizer) {
        if self.passwordField.isSecureTextEntry {
            self.passwordImage.image = UIImage(named: "hide_password_icon")
        } else {
            self.passwordImage.image = UIImage(named: "show_password_icon")
        }
        self.passwordField.isSecureTextEntry = !self.passwordField.isSecureTextEntry
    }
    
    @objc func presentBottomSheet(_ sender: UITapGestureRecognizer) {
        let viewController = ResetPasswordController()
        // Initialize the bottom sheet with the view controller just created
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        // Present the bottom sheet
        present(bottomSheet, animated: true, completion: nil)
    }
    
    func validateFields() {
        if emailAddress.text == "" || passwordField.text == "" {
            let alertController = UIAlertController(title: "Enter credentials", message: "Please ensure to insert all your details", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func loginUser() {
        validateFields()
        self.showSpinner(onView: self.view)
        guard let email = emailAddress.text else { return }
        guard let password = passwordField.text else { return }
        
        let requestHeaders: [String: String] = ["Content-Type": "application/x-www-form-urlencoded" ]
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "mobile-client"),
            URLQueryItem(name: "grant_type", value: "password"),
            URLQueryItem(name: "username", value: email),
            URLQueryItem(name: "password", value: password)
        ]
        
        //Request configuration
        var request = URLRequest(url: URL(string: "http://dev.garihub.com/auth/realms/garihub-rider/protocol/openid-connect/token")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.removeSpinner()
            do {
    
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data!)
                self.viewModel?.client.token = loginResponse.accessToken
                
                DispatchQueue.main.async {
                    self.viewModel?.router.trigger(.root)
                }
                
            } catch {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Invalid credentials", message: "Kind enter valid username and password", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }.resume()
    }
    
    @objc func onTap(_ sender: UIButton) {
        loginUser()
    }
    
}
