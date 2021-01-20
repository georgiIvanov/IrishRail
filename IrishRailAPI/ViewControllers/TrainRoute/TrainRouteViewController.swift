//
//  TrainRouteViewController.swift
//  IrishRailAPI
//
//  Created by Voro on 19.01.21.
//

import Foundation
import UIKit
import MapKit
import RxSwift
import RxCocoa

class TrainRouteViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel: TrainRouteViewModelProtocol!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        viewModel.viewDidLoad()
    }
    
    func setupUI() {
        
    }
    
    func bindUI() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.routeMap.drive { [weak self] (routeData) in
            guard let routeData = routeData else {
                // TODO: Empty state
                return
            }
            
            self?.displayDataOnMap(routeData)
        }.disposed(by: disposeBag)
    }
    
    func displayDataOnMap(_ routeData: RouteMapData) {
        
        routeData.createAnnotations()
        
        let initialLocation = routeData.initialLocation()
        mapView.centerToLocation(initialLocation)
        mapView.addAnnotations(routeData.annotations)
    }
}

// MARK: - MapView Delegate

extension TrainRouteViewController: MKMapViewDelegate {
    func mapView( _ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StationAnnotation else {
            return nil
        }

        let identifier = "station"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? StationAnnotation else {
            return
        }
        
        annotation.mapItem?.openInMaps(launchOptions: nil)
    }
}

extension MKMapView {
  func centerToLocation( _ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                              latitudinalMeters: regionRadius,
                                              longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
