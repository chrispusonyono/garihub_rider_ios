//
//  ClassNameProtocol.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/1/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
