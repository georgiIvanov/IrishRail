//
//  AppConfig.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation

struct AppConfig {
    static var irishRailApiBaseUrl: String {
        return "https://api.irishrail.ie/realtime/realtime.asmx"
    }
    
    static var stubResponses: Bool {
        return false
    }

}
