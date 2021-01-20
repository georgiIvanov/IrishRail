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
        mapView.register(StationMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
        
        mapView.centerToLocation(initialLocation, regionRadius: 7000)
        mapView.addAnnotations(routeData.annotations)
    }
}

extension MKMapView {
  func centerToLocation( _ location: CLLocation, regionRadius: CLLocationDistance) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                              latitudinalMeters: regionRadius,
                                              longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
