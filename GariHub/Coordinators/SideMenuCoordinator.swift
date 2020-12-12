//
//  SideMenuRoutes.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/25/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

enum SideMenuRoutes: Route {
    case pop
}

class SideMenuCoordinator: RedirectionRouter<HomeRoutes, SideMenuRoutes> {
    
    init(client: GariHubClient, parent: UnownedRouter<HomeRoutes>) {
        let sideMenuController = SideMenuController()
        
        sideMenuController.view.backgroundColor = .clear
        sideMenuController.modalPresentationStyle = .custom
        
        super.init(viewController: sideMenuController, parent: parent, map: nil)
        
        let viewModel = SideMenuViewModel(client: client, router: self.strongRouter)
        sideMenuController.viewModel = viewModel
        
        let view = parent.viewController.view
        
        sideMenuController.view.translatesAutoresizingMaskIntoConstraints = false
        sideMenuController.view.widthAnchor.constraint(equalToConstant: (view?.bounds.width)!).isActive = true
        sideMenuController.view.heightAnchor.constraint(equalToConstant: (view?.bounds.height)!).isActive = true
        
    }
    
    
    override func mapToParentRoute(_ route: SideMenuRoutes) -> HomeRoutes {
        switch route {
        case .pop:
            return .popSideMenu(self)
        }
    }
}
