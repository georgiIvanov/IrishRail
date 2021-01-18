//
//  Train.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

struct Train {
    let trainCode: String
    let status: TrainStatus
    let type: TrainType
    let locationType: TrainLocationType
    let dueIn: Int
    let late: Int
    let direction: String
    let trainDate: String
    
    // Format hh:mm
    let scheduledArrival: String
    let expectedArrival: String
    let scheduledDeparture: String
    let expectedDeparture: String
    
    let lastLocation: String?
    let stationName: String?
    let stationCode: String?
    
    var trainMovement: [TrainMovement]
}
