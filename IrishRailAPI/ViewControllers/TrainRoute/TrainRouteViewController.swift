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
    }
}
