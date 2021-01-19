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
    
    @IBOutlet weak var swapStationsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromStationView: TrainStopView!
    @IBOutlet weak var toStationView: TrainStopView!
    
    let disposeBag = DisposeBag()
    var viewModel: TrainsSearchViewModelProtocol!
    var trainRoutes: TrainRoutes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        viewModel.viewDidLoad()
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
        
        viewModel.directTrainRoutes.drive(onNext: { [weak self] (routes) in
            self?.onRoutesFound(routes)
        }).disposed(by: disposeBag)
        
        swapStationsButton.rx.tap.subscribe { [weak viewModel] _ in
            viewModel?.swapStations()
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

extension TrainsSearchViewController {
    func onRoutesFound(_ routes: TrainRoutes?) {
        
        // TODO: Move this at end of method
        trainRoutes = routes
        tableView.reloadData()
        
        guard let routes = routes else {
            // TODO: Empty state - not enough info ot create object
            return
        }
        
        guard routes.directTrains.count > 0 else {
            // TODO: Empty state - no direct routes
            return
        }
    }
}

// MARK: - UITableView Data Source

extension TrainsSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainRoutes?.directTrains.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: "trainRouteCell")!
        guard let cell = reuseCell as? TrainRouteCell else {
            return reuseCell
        }
        
        guard let trainRoutes = trainRoutes else {
            return cell
        }
        
        let train = trainRoutes.directTrains[indexPath.row]
        cell.setup(train, toStation: trainRoutes.toStation)
        
        return cell
    }
}
