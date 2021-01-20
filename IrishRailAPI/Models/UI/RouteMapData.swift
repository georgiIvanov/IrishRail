//
//  RouteMapData.swift
//  IrishRailAPI
//
//  Created by Voro on 19.01.21.
//

import Foundation
import MapKit

// Station name to Train Movement
typealias StationMovement = [String: TrainMovement]

class RouteMapData {
    let stations: [TrainStation]
    let stationNameMovement: StationMovement
    let route: TrainRoutes
    var annotations: [StationAnnotation] = []
    
    init(stations: [TrainStation], stationNameMovement: StationMovement, route: TrainRoutes) {
        self.stations = stations
        self.stationNameMovement = stationNameMovement
        self.route = route
    }
    
    func initialLocation() -> CLLocation {
        return stations[0].location
    }
    
    func createAnnotations() {
        annotations = stations.map {( StationAnnotation(station: $0,
                                                        movement: stationNameMovement[$0.name]) )}
    }
}

extension TrainStation {
    var location: CLLocation {
        return CLLocation(latitude: CLLocationDegrees(latitude),
                          longitude: CLLocationDegrees(longitude))
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                      longitude: CLLocationDegrees(longitude))
    }
}
