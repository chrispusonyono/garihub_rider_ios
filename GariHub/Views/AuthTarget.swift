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
    case register(request: RegisterRequest)
    case validateOTP(request: OTPRequest)
}

extension AuthTarget: TargetType {
    
    
    var baseURL: URL { return URL (string: "http://68.183.242.242/api")! }
    
    var path: String {
        switch self {
        case .validatePhone:
            return "/v1/user/validate-number"
        case .login:
            return "/v1/user/login"
        case .register:
            return "/v1/user/register"
        case .validateOTP:
            return "/v1/user/verify-otp"
            
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
        case .register(let request):
            return [
                "firstName": request.firstName,
                "lastName": request.lastName,
                "gender": request.gender,
                "phoneNumber": request.phoneNumber,
                "emailAddress": request.emailAddress,
                "userType": request.userType,
                "password": request.password
            ]
        case .validateOTP(let request):
            return [
                "phoneNumber": request.phoneNumber,
                "otpCode": request.otpCode
            ]
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validatePhone:
            return .post
        case .login:
            return .post
        case .register:
            return .post
        case .validateOTP:
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
