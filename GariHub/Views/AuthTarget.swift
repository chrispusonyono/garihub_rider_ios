//
//  AuthTarget.swift
//  GariHub
//
//  Created by Kevin Lagat on 25/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import Moya

enum AuthTarget {
    case validatePhone(phoneNumber: String)
    case login(request: LoginRequest)
}

extension AuthTarget: TargetType {
    
    
    var baseURL: URL { return URL (string: "http://68.183.242.242/api")! }
    
    var path: String {
        switch self {
        case .validatePhone:
            return "/v1/user/validate-number"
        case .login:
            return "/v1/user/login"
            
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .validatePhone(let phoneNumber):
            return [
                "phoneNumber": phoneNumber
            ]
        case .login(let request):
            return [
                "emailAddress": request.emailAddress,
                "password": request.password
            ]
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validatePhone:
            return .post
        case .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters,
                                      encoding: JSONEncoding.default)
        }
        return .requestPlain
        
    }

    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
    
    
    
}
