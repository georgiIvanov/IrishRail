//
//  StationMarkerView.swift
//  IrishRailAPI
//
//  Created by Voro on 20.01.21.
//

import Foundation
import MapKit

class StationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? StationAnnotation else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let buttonSide = 40
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: buttonSide, height: buttonSide)))
            mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
            mapsButton.tintColor = .systemBlue
            mapsButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            
            rightCalloutAccessoryView = mapsButton
            
            markerTintColor = .systemBlue
            if let letter = annotation.station.name.first {
                glyphText = String(letter)
            }
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.textAlignment = .center
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = annotation.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
    
    @objc
    func didTapButton(_ sender: Any?) {
        guard let annotation = annotation as? StationAnnotation else {
            print("Unexpected annotation type - \(String(describing: sender)), could not open maps.")
            return
        }
        
        annotation.mapItem?.openInMaps(launchOptions: nil)
    }
}
