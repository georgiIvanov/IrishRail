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
        return configValue(for: "API_BASE_URL")
    }
    
    static var stubResponses: Bool {
        return configValue(for: "STUB_RESPONSE")
    }
    
    static func getAppVersion() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            print("Could not get app version string.")
            return ""
        }
        
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            print("Could not build number string.")
          return ""
        }
        
        guard let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else {
            print("Could not get app name string.")
            return ""
        }
        
        return "\(appName) v\(appVersion) (\(buildNumber))"
    }
    
    static var appMainColor: UIColor {
        return UIColor(red: 0.78, green: 0.27, blue: 0.25, alpha: 1.00)
    }
    
    static func configValue<T>(for key: String) -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            fatalError("Missing Info.plist key: \(key)")
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            fatalError("Invalid value with key: \(key)")
        }
    }
}
