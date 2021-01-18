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
        viewModel.fromTrainStation.drive { [weak self] (station) in
            self?.fromStationView.setLocationText(station?.nameAndAlias() ?? nil)
        }.disposed(by: disposeBag)

        viewModel.toTrainStation.drive { [weak self] (station) in
            self?.toStationView.setLocationText(station?.nameAndAlias() ?? nil)
        }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterVc = segue.destination as? TrainStationsFilterViewController,
           let view = sender as? TrainStopView {
            
            filterVc.viewModel.trainStations = viewModel.trainStations
            
            if view.direction.range(of: "from", options: .caseInsensitive) != nil {
                filterVc.onSelected = { [weak viewModel] (selected) in
                    viewModel?.setFromStation(selected)
                }
            } else if view.direction.range(of: "to", options: .caseInsensitive) != nil {
                filterVc.onSelected = { [weak viewModel] (selected) in
                    viewModel?.setToStation(selected)
                }
            } else {
                print("Unexpected direction: \(view.direction). TrainStopView's direction should be to/from")
            }
        }
    }
}
