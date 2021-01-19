//
//  TrainRouteViewModel.swift
//  IrishRailAPI
//
//  Created by Voro on 19.01.21.
//

import Foundation
import RxSwift
import RxCocoa

protocol TrainRouteViewModelProtocol {
    var allTrainStations: BehaviorSubject<[TrainStation]>! { get set }
    var routeMap: Driver<RouteMapData?> { get }
    
    func setTrainRoute(_ trainRoute: TrainRoutes)
    func viewDidLoad()
}

class TrainRouteViewModel {
    var allTrainStations: BehaviorSubject<[TrainStation]>!
    let trainRouteSubject = BehaviorSubject<TrainRoutes?>(value: nil)
    let routeMapSubject = PublishSubject<RouteMapData?>()
    let disposeBag = DisposeBag()
}

extension TrainRouteViewModel: TrainRouteViewModelProtocol {
    var routeMap: Driver<RouteMapData?> {
        routeMapSubject.asDriver(onErrorJustReturn: nil)
    }
    
    var trainRoute: Driver<TrainRoutes?> {
        return trainRouteSubject.filterOutNull().asDriver(onErrorJustReturn: nil)
    }
    
    func setTrainRoute(_ trainRoute: TrainRoutes) {
        trainRouteSubject.onNext(trainRoute)
    }
    
    func viewDidLoad() {
        Observable.combineLatest(allTrainStations,
                                 trainRouteSubject.filterOutNull())
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
        .map { (stations, route: TrainRoutes) -> RouteMapData in
            let filteredStations = TrainRouteViewModel.getStations(stations, onRoute: route)
            return RouteMapData(stations: filteredStations, route: route)
        }
        .observeOn(MainScheduler.asyncInstance)
        .bind(to: routeMapSubject)
        .disposed(by: disposeBag)
    }
}

extension TrainRouteViewModel {
    
    // Gets all train station objects along a train's movement route
    static func getStations(_ stations: [TrainStation], onRoute route: TrainRoutes) -> [TrainStation] {
        // This VC displays only one train route so this is safe
        let train = route.directTrains[0]
        var stationsResult = [TrainStation]()
        
        for idx in 0..<train.trainMovement.count {
            let mov = train.trainMovement[idx]
            if mov.stationCode == route.fromStation.code {
                for idx2 in idx..<train.trainMovement.count {
                    let movementToFind = train.trainMovement[idx2]
                    if let station = stations.first(where: { $0.code == movementToFind.stationCode }) {
                        stationsResult.append(station)
                    }
                    
                    if movementToFind.stationCode == route.toStation.code {
                        break
                    }
                }
                break
            }
        }
        
        return stationsResult
    }
}
