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
        
        let regTap = UITapGestureRecognizer(target: self, action: #selector(self.goToRegister(_:)))
        registerButton.isUserInteractionEnabled = true
        registerButton.addGestureRecognizer(regTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func goToRegister(_ sender: UITapGestureRecognizer) {
        self.viewModel?.router.trigger(.validatePhone)
    }
    
    @objc func presentBottomSheet(_ sender: UITapGestureRecognizer) {
        let viewController = ResetPasswordController()
        // Initialize the bottom sheet with the view controller just created
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        // Present the bottom sheet
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @objc
    private func keyboardWillHide() {
        guard view.frame.origin.y != 0 else { return }
        
        view.frame.origin.y = 0
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard
            let size = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            view.frame.origin.y == 0 else {  return }
        
        view.frame.origin.y -= (size.height / 2)
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
        var request = URLRequest(url: URL(string: "http://68.183.242.242/auth/realms/garihub-rider/protocol/openid-connect/token")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.removeSpinner()
            do {
    
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data!)
                self.viewModel?.client.token = loginResponse.accessToken
                
                DispatchQueue.main.async {
                    self.viewModel?.router.trigger(.dashboard)
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
