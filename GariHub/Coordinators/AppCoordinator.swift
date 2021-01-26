//
//  AppCoordinator.swift
//  GariHub
//
//  Created by Kevin Lagat on 12/6/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import XCoordinator

enum AppRoutes: Route {
    case landingPage
    case dashboard
    case destination
    case onboarding(_ presentable: Presentable)
    case performTransition(_ transition: Transition<UINavigationController>)
    case popSideMenu(_ presentable: Presentable)
    case push(_ presentable: Presentable)
    case side(_ presentable: Presentable)
}


@available(iOS 12.0, *)
@available(iOS 12.0, *)
class AppCoordinator: NavigationCoordinator<AppRoutes> {
    let client: GariHubClient
    
    init() {
        self.client = GariHubClient()
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.backgroundColor = UIColor.black
        navigationController.navigationBar.barTintColor = UIColor.black
        navigationController.navigationBar.tintColor = .black
        
        super.init(rootViewController: navigationController, initialRoute: .dashboard )
    }
    
    override func prepareTransition(for route: AppRoutes) -> NavigationTransition {
        
        
        switch route {
            
        case .dashboard:
            let homeCoordinator = HomeCoordinator(client: client)
            homeCoordinator.appCoordinatorDelegate = self
            return homeCoordinator.prepareTransition(for: .root)
            
        case .landingPage:
            let onboardingCoordinator = OnboardingCoordinator()
            onboardingCoordinator.appCoordinatorDelegate = self
            return onboardingCoordinator.prepareTransition(for: .validatePhone)
            
        case .performTransition(let transition):
            return transition
        case .popSideMenu(let presentable):
            return .unembed(presentable, animation: Animation.side.dismissalAnimation)
        case .push(let presentable):
            return .push(presentable)
            
        case .side(let presentable):
            return .embed(presentable, in: self.rootViewController, animation: Animation.side.presentationAnimation)
        case .onboarding(let presentable):
            return .set([presentable])
        case .destination:
            let homeCoordinator = HomeCoordinator(client: client)
            homeCoordinator.appCoordinatorDelegate = self
            return homeCoordinator.prepareTransition(for: .destination)
        }
    }
    
}

protocol AppCoordinatorDelegate {
    func selectRoute(_ route: AppRoutes)
}

@available(iOS 12.0, *)
extension AppCoordinator: AppCoordinatorDelegate {
    func selectRoute(_ route: AppRoutes) {
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
