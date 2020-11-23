//
//  SideMenuViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/25/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class SideMenuViewModel: BaseAuthModel {
    let router: StrongRouter<SideMenuRoutes>
    
    init(client: GariHubClient, router: StrongRouter<SideMenuRoutes>) {
        self.router = router
        super.init(client: client)
    }
}
