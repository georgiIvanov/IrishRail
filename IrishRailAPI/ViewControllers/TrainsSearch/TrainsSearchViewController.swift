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
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var messageLabel: MessageLabel!
    
    let disposeBag = DisposeBag()
    var viewModel: TrainsSearchViewModelProtocol!
    var timeTicker: TimeTickerProtocol!
    var trainRoutes: TrainRoutes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        viewModel.viewDidLoad()
        fetchTrainStations()
    }
    
    func setupUI() {
        view.bringSubviewToFront(appLogoImageView)
        messageLabel.alpha = 0
        
        fromStationView.onViewTap = { [weak self] (view)  in
            self?.performSegue(withIdentifier: "trainStationsFilterSegue", sender: view)
        }
    
        fromStationView.onClearButtonTap = { [weak viewModel] (view)  in
            viewModel?.setFromStation(nil)
        }
        
        toStationView.onViewTap = { [weak self] (view)  in
            self?.performSegue(withIdentifier: "trainStationsFilterSegue", sender: view)
        }
        
        toStationView.onClearButtonTap = { [weak viewModel] (view)  in
            viewModel?.setToStation(nil)
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

        viewModel.error.drive(onNext: { [weak messageLabel, weak appLogoImageView] (error) in
            messageLabel?.animateViewAlphaToAppear()
            appLogoImageView?.animateViewAlphaToDisappear()
            messageLabel?.present(error)
        }).disposed(by: disposeBag)
    }
    
    func fetchTrainStations() {
        viewModel.fetchTrainStations().subscribe(onSuccess: { [weak self] (_) in
            if self?.messageLabel.isPresentingError == true {
                self?.messageLabel.animateViewAlphaToDisappear()
                self?.appLogoImageView.animateViewAlphaToAppear()
            }
            self?.timeTicker.stopTimer()
        }, onError: { [weak messageLabel, weak appLogoImageView, weak self] (error) in
            appLogoImageView?.animateViewAlphaToDisappear()
            messageLabel?.animateViewAlphaToAppear()
            messageLabel?.present(error)
            self?.retryStationsFetchRequest()
        }).disposed(by: disposeBag)
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
        } else if let mapVc = segue.destination as? TrainRouteViewController,
                  let route = sender as? TrainRoutes {
            mapVc.viewModel.allTrainStations = viewModel.trainStations
            mapVc.viewModel.setTrainRoute(route)
        }
    }
}

extension TrainsSearchViewController {
    func onRoutesFound(_ routes: TrainRoutes?) {
        
        trainRoutes = routes
        tableView.reloadData()
        
        guard let routes = routes else {
            appLogoImageView.animateViewAlphaToAppear()
            messageLabel.animateViewAlphaToDisappear()
            return
        }
        
        appLogoImageView.alpha = 0
        
        if routes.directTrains.count == 0 {
            messageLabel.present("No direct trains found.")
            messageLabel.animateViewAlphaToAppear()
        } else {
            messageLabel.alpha = 0
        }
    }
    
    func retryStationsFetchRequest() {
        guard timeTicker.timerHasStarted == false else {
            return
        }
        
        timeTicker.timeTick.subscribe { [weak self] _ in
            self?.fetchTrainStations()
        }.disposed(by: disposeBag)
        
        timeTicker.startTimer(interval: 5)
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

extension TrainsSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let trainRoutes = trainRoutes else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TrainRouteCell else {
            print("Unexpected cell type, did select will not work")
            return
        }
        
        if cell.isTrainTransit() {
            print("Train is transit for To Station, will not display it on map.")
            return
        }
        
        let routeToShow = trainRoutes.copyWithOnlyTrainAt(index: indexPath.row)
        performSegue(withIdentifier: "trainRouteSegue", sender: routeToShow)
    }
}
