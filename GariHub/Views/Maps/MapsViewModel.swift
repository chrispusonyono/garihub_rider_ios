//
//  MapsViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/4/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class MapsViewModel: BaseAuthModel {
    let router: StrongRouter<HomeRoutes>
    
    init(client: GariHubClient, router: StrongRouter<HomeRoutes>) {
        self.router = router
        super.init(client: client)
    }
}
