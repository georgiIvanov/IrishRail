//
//  TrainMovement.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

struct TrainMovement {
    let trainCode: String
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
    
    func trainStopsAtThisLocation() -> Bool {
        return locationType == .stop ||
            locationType == .origin ||
            locationType == .destination
    }
    
    func expectedArrivalIsInvalid() -> Bool {
        return expectedArrival == "00:00:00"
    }
}
