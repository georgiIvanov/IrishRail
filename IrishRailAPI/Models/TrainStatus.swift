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
    
    init?(string: String) {
        switch string {
        case "R":
            self = .running
        case "N":
            self = .notRunning
        default:
            self = .noInformation
        }
    }
}
