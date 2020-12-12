//
//  BaseTextFieldController.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/30/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class BaseTextFieldController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func setImageViewNavigationBar() {
        if #available(iOS 13.0, *) {
            
            let statusBar = UIView()
            statusBar.frame = UIApplication.shared.windows.last?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            statusBar.backgroundColor = .black
            UIApplication.shared.windows.last?.addSubview(statusBar)
        }
        else {
            guard let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView else {
                return
            }
            if statusBarView.responds(to: #selector(setter: UIView.backgroundColor)) {
                statusBarView.backgroundColor = .clear
            }
        }
    }
    
    func setClearNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.clear
        
    }
    
    func setAppNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .appYellow
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = .appYellow
    }
    
    func setTransparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        self.navigationController?.navigationBar.shadowImage = .init()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        setClearNavigationBar()
    }


}
