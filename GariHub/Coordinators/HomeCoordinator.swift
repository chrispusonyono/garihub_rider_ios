//
//  HomeRoutes.swift
//  GariHub
//
//  Created by Kevin Lagat on 12/6/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

enum HomeRoutes: Route {
    case dismiss
    case dismissToRoot
    case popSideMenu(_ presentable: Presentable)
    case side
    case root
    case bookRide
    case destination
    case maps
}


@available(iOS 12.0, *)
class HomeCoordinator: NavigationCoordinator<HomeRoutes> {
    
    let client: GariHubClient
    
    var appCoordinatorDelegate: AppCoordinatorDelegate?
    
    init(client: GariHubClient) {
        self.client = client
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.backgroundColor = UIColor.black
        navigationController.navigationBar.barTintColor = UIColor.black
        navigationController.navigationBar.tintColor = .black
        
        super.init(rootViewController: navigationController, initialRoute: nil)
    }
    
    override func prepareTransition(for route: HomeRoutes) -> NavigationTransition {
        switch route {
            
        case .dismiss:
            self.appCoordinatorDelegate?.selectRoute(.performTransition(.pop()))
            return .none()
        case .dismissToRoot:
            self.appCoordinatorDelegate?.selectRoute(.performTransition(.dismissToRoot()))
            return .none()
        case .popSideMenu(let presentable):
            self.appCoordinatorDelegate?.selectRoute(.popSideMenu(presentable))
            return .none()
        case .side:
            let sideMenuCoordinator = SideMenuCoordinator(client: client, parent: unownedRouter)
            self.appCoordinatorDelegate?.selectRoute(.side(sideMenuCoordinator))
            return .none()
        
        case .root:
            let viewModel = DashboardViewModel(client: client, router: self.strongRouter)
            let dashboard = DashboardController()
            dashboard.viewModel = viewModel
            
            self.appCoordinatorDelegate?.selectRoute(.onboarding(dashboard))
            return .none()
            
            
        case .bookRide:
            let viewModel = BookRideViewModel(client: client, router: self.strongRouter)
            let bookRide = BookRideController()
            bookRide.viewModel = viewModel
            
            self.appCoordinatorDelegate?.selectRoute(.push(bookRide))
            return .none()
            
        case .destination:
            let viewModel = DestinationViewModel(client: client, router: self.strongRouter)
            let destination = Destination()
            destination.viewModel = viewModel
            
            self.appCoordinatorDelegate?.selectRoute(.push(destination))
            return .none()
        case .maps:
            let viewModel = MapsViewModel(client: client, router: self.strongRouter)
            let mapsVC = MapsController()
            mapsVC.viewModel = viewModel
            
            self.appCoordinatorDelegate?.selectRoute(.push(mapsVC))
            return .none()
        }
    }
    
}
 
