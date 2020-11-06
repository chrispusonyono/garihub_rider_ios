//
//  UIView+.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/6/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import UIKit

extension UIView: ClassNameProtocol {
    
    class func fromNib<T: UIView>(nibName: String) -> T {
        guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?[0] as? T else {
            return T()
        }
        return view
    }
}
