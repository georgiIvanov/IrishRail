//
//  StationAnnotation.swift
//  IrishRailAPI
//
//  Created by Voro on 20.01.21.
//

import Foundation
import MapKit

class StationAnnotation: NSObject {
    let station: TrainStation
    
    init(station: TrainStation) {
        self.station = station
        super.init()
    }
}

extension StationAnnotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return station.locationCoordinate
    }
    
    var title: String? {
        return station.name
    }

    var subtitle: String? {
        return nil
    }
}
