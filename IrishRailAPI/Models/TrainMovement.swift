//
//  TrainMovement.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

struct TrainMovement {
    let stationCode: String
    let stationName: String
    let order: Int
    let locationType: TrainLocationType
    let stopType: StopType
    
    // Format hh:mm:ss
    let scheduledArrival: String
    let expectedArrival: String
    let scheduledDeparture: String
    let expectedDeparture: String
}
