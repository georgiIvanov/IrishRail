//
//  TrainsSearchViewController.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TrainsSearchViewController: UIViewController {
    
    @IBOutlet weak var fromStationView: TrainStopView!
    @IBOutlet weak var toStationView: TrainStopView!
    
    let disposeBag = DisposeBag()
    var viewModel: TrainsSearchViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        viewModel.getTrainStations()
    }
    
    func setupUI() {
        fromStationView.onViewTap = { [weak self] (view)  in
            self?.performSegue(withIdentifier: "trainStationsFilterSegue", sender: view)
        }
        
        toStationView.onViewTap = { [weak self] (view)  in
            self?.performSegue(withIdentifier: "trainStationsFilterSegue", sender: view)
        }
    }
    
    func bindUI() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterVc = segue.destination as? TrainStationsFilterViewController,
           let view = sender as? TrainStopView {
            filterVc.viewModel.trainStations = viewModel.trainStations
            print(view.direction)
            // TODO: setup filter bindings
        }
    }
}
