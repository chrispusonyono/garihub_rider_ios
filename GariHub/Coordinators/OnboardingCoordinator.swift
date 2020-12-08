//
//  OnboardingCoordinator.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

enum OnboardingRoutes:  Route  {
    case root
    case emailReg(phoneNumber: String, fullName:String, gender: String)
    case login
    case otp(phoneNumber: String)
    case passReg(phoneNumber: String, fullName:String, gender: String, email: String)
    case registerTwo(phoneNumber: String)
    case validatePhone
    case dismiss
    
}

class OnboardingCoordinator: NavigationCoordinator<OnboardingRoutes> {
    let client: GariHubClient
    var appCoordinatorDelegate: AppCoordinatorDelegate?
    
    init() {
        self.client = GariHubClient()
        let navigationController = UINavigationController()
        navigationController.navigationBar.backgroundColor = UIColor.appYellow
        navigationController.navigationBar.barTintColor = UIColor.appYellow
        navigationController.navigationBar.tintColor = .black
        
        super.init(rootViewController: navigationController, initialRoute: nil)

    }
    
    override func prepareTransition(for route: OnboardingRoutes) -> NavigationTransition {
        
        
        switch route {

        case .dismiss:
            return .none()
            
        case .otp(let phoneNumber):
            let viewModel = OTPViewModel(client: client, phoneNumber: phoneNumber, router: self.strongRouter)
            let otpController = OTPController()
            otpController.viewModel = viewModel
            return .set([otpController])
            
        case .validatePhone:
            let viewModel = RegistrationViewModel(client: client, router: self.strongRouter)
            let regVC = RegistrationController()
            regVC.viewModel = viewModel
            return .set([regVC])
            
        case .registerTwo(let phoneNumber):
            let viewModel = RegTwoViewModel(client: client, router: self.strongRouter, phoneNumber: phoneNumber)
            let regTwoVC = RegistrationTwoController()
            regTwoVC.viewModel = viewModel
            return .set([regTwoVC])

        case .emailReg(let phoneNumber, let fullName, let gender):
            let viewModel = EmailRegViewModel(client: client, router: self.strongRouter, phoneNumber: phoneNumber, fullName: fullName, gender: gender)
            let emailRegVc = EmailRegisterController()
            emailRegVc.viewModel = viewModel
            return .set([emailRegVc])
            
        case .passReg(let phoneNumber, let fullName, let gender, let email):
            let viewModel = PasswordRegViewModel(client: client, router: self.strongRouter, phoneNumber: phoneNumber, fullName: fullName, gender: gender, emailAddress: email)
            let passRegVc = PasswordRegisterController()
            passRegVc.viewModel = viewModel
            return .set([passRegVc])
        
        case .root:
            self.appCoordinatorDelegate?.selectRoute(.dashboard)
            return .none()
            
        case .login:
            let viewModel = LoginViewModel(client: client, router: self.strongRouter)
            let loginVC = LoginController()
            loginVC.viewModel = viewModel
            return .set([loginVC])
        }
    }
}
