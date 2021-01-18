//
//  TrainRoute.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

struct TrainRoute {
    let fromStation: TrainStation
    let toStation: TrainStation
    let directTrains: [Train]
}
