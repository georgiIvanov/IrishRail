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
