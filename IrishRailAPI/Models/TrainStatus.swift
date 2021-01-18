//
//  TrainStatus.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

enum TrainStatus {
    case running
    case notRunning
    case noInformation
    
    init(string: String) {
        switch string {
        case "En Route":
            self = .running
        case "N":
            self = .notRunning
        case "No Information":
            self = .noInformation
        default:
            print("Found unexpected train status: \(string), defaulting to no information.")
            self = .noInformation
        }
    }
}
