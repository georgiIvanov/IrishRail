//
//  StationAnnotation.swift
//  IrishRailAPI
//
//  Created by Voro on 20.01.21.
//

import Foundation
import MapKit
import Contacts

class StationAnnotation: NSObject {
    let station: TrainStation
    let movement: TrainMovement?
    
    init(station: TrainStation, movement: TrainMovement?) {
        self.station = station
        self.movement = movement
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
        guard let movement = movement,
              movement.expectedArrivalIsInvalid() == false else {
            return nil
        }
        
        return "Expected Arrival:\n\(movement.expectedArrival)"
    }
}

extension StationAnnotation {
    var mapItem: MKMapItem? {
      guard let location = title else {
        return nil
      }

      let addressDict = [CNPostalAddressStreetKey: location]
      let placemark = MKPlacemark(
        coordinate: coordinate,
        addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
}
