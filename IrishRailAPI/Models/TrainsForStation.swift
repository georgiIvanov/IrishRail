//
//  TrainsForStation.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

struct TrainsForStation {
    let trainStation: TrainStation?
    let trains: [Train]
    
    static func empty() -> TrainsForStation {
        TrainsForStation.init(trainStation: nil, trains: [])
    }
}
