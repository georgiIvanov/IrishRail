//
//  UIViewController+Extensions.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import UIKit

public extension UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
