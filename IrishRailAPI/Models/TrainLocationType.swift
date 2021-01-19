//
//  LocationType.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

enum TrainLocationType {
    case origin
    case destination
    case stop
    // non stopping location
    case timingPoint
    case invalidData
    
    init(string: String) {
        switch string {
        case "O":
            self = .origin
        case "D":
            self = .destination
        case "S":
            self = .stop
        case "T":
            self = .timingPoint
        default:
            print("Unexpected location type \(string), defaulting to invalidData")
            self = .invalidData
        }
    }
}
