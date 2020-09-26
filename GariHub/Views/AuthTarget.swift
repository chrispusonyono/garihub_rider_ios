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
}

extension AuthTarget: TargetType {
    
    
    var baseURL: URL { return URL (string: "http://68.183.242.242/api")! }
    
    var path: String {
        switch self {
        case .validatePhone:
            return "/v1/user/validate-number"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .validatePhone(let phoneNumber):
            return [
                "phoneNumber": phoneNumber
            ]
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validatePhone:
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
