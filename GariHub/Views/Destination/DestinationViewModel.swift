//
//  DestinationViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/29/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class DestinationViewModel: BaseAuthModel {
    let router: StrongRouter<HomeRoutes>
    
    init(client: GariHubClient, router: StrongRouter<HomeRoutes>) {
        self.router = router
        super.init(client: client)
    }
}
