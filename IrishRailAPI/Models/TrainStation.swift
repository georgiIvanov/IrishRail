//
//  TrainStation.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation

struct TrainStation {
    let stationId: Int
    let name: String
    let alias: String?
    let latitude: Double
    let longitude: Double
    let code: String
    
    func nameAndAlias() -> String {
        var fullName = name
        if let alias = alias, alias.isEmpty == false {
            fullName += " (\(alias))"
        }
        
        return fullName
    }
}
