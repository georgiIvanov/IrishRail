//
//  TrainsForStation.swift
//  IrishRailAPI
//
//  Created by Voro on 18.01.21.
//

import Foundation

class TrainsForStation {
    let trainStation: TrainStation?
    var trains: [Train]
    
    private init() {
        self.trainStation = nil
        self.trains = []
    }
    
    init(trainStation: TrainStation?, trains: [Train]) {
        self.trainStation = trainStation
        self.trains = trains
    }
    
    static func empty() -> TrainsForStation {
        TrainsForStation()
    }
    
    func assignMovementsToTrains(_ trainMovements: [[TrainMovement]]) {
        for idx in 0..<trains.count {
            if let movement = trainMovements.first(where: { (mov) -> Bool in
                return mov.first?.trainCode == trains[idx].trainCode
            }) {
                trains[idx].trainMovement = movement
            }
        }
        
    }
}
