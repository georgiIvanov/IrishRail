//
//  TrainRoute.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

struct TrainRoutes {
    let fromStation: TrainStation
    let toStation: TrainStation
    let directTrains: [Train]
    
    func copyWithOnlyTrainAt(index: Int) -> TrainRoutes {
        return TrainRoutes(fromStation: fromStation,
                           toStation: toStation,
                           directTrains: [directTrains[index]])
    }
}
