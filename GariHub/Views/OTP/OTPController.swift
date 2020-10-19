//
//  OTPController.swift
//  GariHub
//
//  Created by Chrispus Onyono on 30/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class OTPController: UIViewController {
    
    var viewModel: OTPViewModel?

    var activeTextField: UITextField?
    
    @IBOutlet weak var resendOTPbtn: UIView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var textFieldFooters: [UIView]!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var resendOTP: UILabel!
    
    @IBOutlet weak var level2: UIView!
    @IBOutlet weak var level1: UIView!
    @IBOutlet weak var level0: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        submitBtn.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        level0.layer.cornerRadius = 15
        level0.clipsToBounds = true
        
        level1.layer.cornerRadius = 15
        level1.clipsToBounds = true
        
        level2.layer.cornerRadius = 15
        level2.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func onTap(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        
        guard let vm = self.viewModel else { return }
        let request = OTPRequest(phoneNumber: vm.phoneNumber, otpCode: getOtpString())
        
        vm.provider.request(.validateOTP(request: request)) {
            result in
            self.removeSpinner()
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                do {
                    let otpResponse = try JSONDecoder().decode(RegOTPResponse.self, from: response.data)
                    print(otpResponse)
                    self.viewModel?.router.trigger(.registerTwo(phoneNumber: vm.phoneNumber))
                } catch {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Error", message: "Invalid One Time Passcode, Resend again", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true)
                    }
                }
            }
        }
    }
    
    func getOtpString() -> String {
        var otp: String = ""
        
        textFields?.forEach { (textfield) in
            otp += textfield.text ?? ""
        }
        
        return otp
    }
    
    @discardableResult
       func moveCursor(textCount: Int, textField: UITextField) -> Bool {
           guard
               let textFields = self.textFields,
               textCount >= 1 else { return false }
           
           for field in textFields {
               
               if textField == textFields.last {
                   textField.resignFirstResponder()
                   return true
               }
                   
               else if field != textField {
                   guard
                       let index = textFields.firstIndex(of: textField),
                       index < (textFields.count - 1) else { return false }
                   
                   let nextTextField = textFields[index+1]
                   nextTextField.becomeFirstResponder()
                   
                   return true
               }
           }
           
           return false
       }
       
       @discardableResult
       func moveCursorOnDelete(textCount: Int, textField: UITextField) -> Bool {
           guard
               let textFields = self.textFields,
               let index = textFields.firstIndex(of: textField),
               index > 0 else { return false }
           
           self.textFieldFooters?[index].backgroundColor = UIColor.lightGray
           
           let previousField = textFields[index - 1]
           previousField.becomeFirstResponder()
           
           return true
       }
       
       func isTextFieldEmpty() -> Bool {
           return self.getOtpString().count == 6
       }
}


extension OTPController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    @objc
    func textFieldDidChange(notification: Notification) {
        guard
            let activeTextField = self.activeTextField,
            let textField = notification.object as? UITextField,
            activeTextField == textField else { return }
        
        let count = activeTextField.text?.count ?? 0
        
        if !moveCursor(textCount: count, textField: activeTextField) {
            moveCursorOnDelete(textCount: count, textField: activeTextField)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 1
        
        guard let currentText = textField.text
            else { return false }
        
        let input: NSString = currentText as NSString
        let newInput: NSString = input.replacingCharacters(in: range, with: string) as NSString
        return newInput.length <= maxLength
    }
}
