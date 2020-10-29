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
    case destination
    case dashboard
    case emailReg(phoneNumber: String, fullName:String, gender: String)
    case login
    case otp(phoneNumber: String)
    case passReg(phoneNumber: String, fullName:String, gender: String, email: String)
    case registerTwo(phoneNumber: String)
    case validatePhone
    
}

class OnboardingCoordinator: NavigationCoordinator<OnboardingRoutes> {
    let client: GariHubClient
    
    init() {
        self.client = GariHubClient()
        let navigationController = UINavigationController()
        navigationController.navigationBar.backgroundColor = UIColor.appYellow
        navigationController.navigationBar.barTintColor = UIColor.appYellow
        navigationController.navigationBar.tintColor = .black
        
        super.init(rootViewController: navigationController, initialRoute: .validatePhone)

    }
    
    override func prepareTransition(for route: OnboardingRoutes) -> NavigationTransition {
        switch route {
        case .destination:
            let viewModel = DestinationViewModel(client: client, router: self.strongRouter)
            let destination = Destination()
            destination.viewModel = viewModel
            return .set([destination])
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
            
        case .dashboard:
            let viewModel = DashboardViewModel(client: client, router: self.strongRouter)
            let dashboard = DashboardController()
            dashboard.viewModel = viewModel
            return .set([dashboard])
        case .login:
            let viewModel = LoginViewModel(client: client, router: self.strongRouter)
            let loginVC = LoginController()
            loginVC.viewModel = viewModel
            return .set([loginVC])
        }
    }
}

protocol AppCoordinatorDelegate {
    func selectRoute(_ route: OnboardingRoutes)
}

extension OnboardingCoordinator: AppCoordinatorDelegate {
    func selectRoute(_ route: OnboardingRoutes) {
        self.strongRouter.trigger(route)
    }
}


extension Transition {
    static func dismissAll() -> Transition {
        return Transition(presentables: [], animationInUse: nil) { rootViewController, options, completion in
            guard let presentedViewController = rootViewController.presentedViewController else {
                completion?()
                return
            }
            presentedViewController.dismiss(animated: options.animated) {
                Transition.dismissAll()
                    .perform(on: rootViewController, with: options, completion: completion)
            }
        }
    }
}
