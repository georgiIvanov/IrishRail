//
//  AppConfig.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation
import UIKit

struct AppConfig {
    static var irishRailApiBaseUrl: String {
        return "https://api.irishrail.ie/realtime/realtime.asmx"
    }
    
    static var stubResponses: Bool {
        return false
    }
    
    static var appMainColor: UIColor {
        return UIColor(red: 0.78, green: 0.27, blue: 0.25, alpha: 1.00)
    }
}
