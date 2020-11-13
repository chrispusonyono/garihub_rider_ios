//
//  GariHubClient.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import Moya
import SwiftKeychainWrapper

class GariHubClient {
    static let shared: KeychainWrapper = KeychainWrapper.standard
    
    var isLoggedIn: Bool {
        if savedToken == "" || savedToken == nil {
            return false
        }
        return true
    }

    
    private var savedToken: String? {
        return GariHubClient.shared.string(forKey: "token")
    }
        
    
    var token: String {
        get {
            return self.savedToken ?? ""
        }
        set {
            GariHubClient.shared.set(newValue, forKey: "token")
        }
    }

    
    func logout() {
        GariHubClient.shared.removeAllKeys()
    }
}

