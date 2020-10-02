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



class RegistrationController: UIViewController {
    
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var activateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        activateButton.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
    }
    
    @objc func onTap(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
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

extension RegistrationController {
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
}
