//
//  LoginRequest.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/1/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let clientID, grantType, username, password: String

    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case grantType = "grant_type"
        case username, password
    }
    
}

struct LoginResponse: Codable {
    let accessToken: String
    let expiresIn, refreshExpiresIn: Int
    let refreshToken, tokenType: String
    let notBeforePolicy: Int
    let sessionState, scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case notBeforePolicy = "not-before-policy"
        case sessionState = "session_state"
        case scope
    }
}

