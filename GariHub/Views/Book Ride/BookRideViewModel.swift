//
//  BookRideViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/13/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class BookRideViewModel: BaseRideModel {
    let router: StrongRouter<HomeRoutes>
    
    init(client: GariHubClient, router: StrongRouter<HomeRoutes>) {
        self.router = router
        super.init(client: client)
    }
}
