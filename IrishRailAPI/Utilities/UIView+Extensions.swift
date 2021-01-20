//
//  UIView+Extensions.swift
//  IrishRailAPI
//
//  Created by Voro on 20.01.21.
//

import Foundation
import UIKit

extension UIView {
    func animateViewAlphaToAppear(_ duration: Double = 0.4) {
        guard alpha < 1 else {
            return
        }
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
    }
    
    func animateViewAlphaToDisappear(_ duration: Double = 0.4) {
        guard alpha > 0 else {
            return
        }
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        }
    }
}
