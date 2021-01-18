//
//  StopType.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

enum StopType {
    case current
    case next
    case unknown
    
    init(string: String) {
        switch string {
        case "C":
            self = .current
        case "N":
            self = .next
        default:
            self = .unknown
        }
    }
}
