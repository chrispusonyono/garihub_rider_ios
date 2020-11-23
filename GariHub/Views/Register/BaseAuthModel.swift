//
//  BaseAuthModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 25/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import Moya


class BaseAuthModel {
    
    let authPlugin: AccessTokenPlugin
    let client: GariHubClient
    let provider: MoyaProvider<AuthTarget>
    
    init(client: GariHubClient) {
        self.authPlugin = AccessTokenPlugin { _ in client.token }
        self.client = client
        self.provider = MoyaProvider<AuthTarget>(plugins: [authPlugin, NetworkLoggerPlugin()])
    }
}

class BaseRideModel {
    let authPlugin: AccessTokenPlugin
    let client: GariHubClient
    let provider: MoyaProvider<RidesTarget>
    
    init(client: GariHubClient) {
        self.authPlugin = AccessTokenPlugin { _ in client.token }
        self.client = client
        self.provider = MoyaProvider<RidesTarget>(plugins: [authPlugin, NetworkLoggerPlugin()])
    }
}
