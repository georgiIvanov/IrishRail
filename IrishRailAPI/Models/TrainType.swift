//
//  TrainType.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

enum TrainType {
    case dart
    // exists in docs, but never found an example of
    // how it's named in the actual XML data
//    case intercity
    case train
    
    init(type: String) {
        switch type {
        case "Train":
            self = .train
        case "DART":
            self = .dart
        default:
            print("Found unexpected train type: \(type), defaulting to train.")
            self = .train
        }
    }
    
}
