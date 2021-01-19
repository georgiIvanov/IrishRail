//
//  TrainsSearchViewModel.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol TrainsSearchViewModelProtocol: class {
    
    var trainStations: BehaviorSubject<[TrainStation]> { get }
    var fromTrainStation: Driver<TrainStation?> { get }
    var toTrainStation: Driver<TrainStation?> { get }
    var directTrainRoutes: Driver<TrainRoutes?> { get }
    var error: Driver<Error> { get }
    
    func getTrainStations()
    func setFromStation(_ station: TrainStation)
    func setToStation(_ station: TrainStation)
    func swapStations()
    func viewDidLoad()
}

class TrainsSearchViewModel {
    
    let trainStations = BehaviorSubject<[TrainStation]>(value: [])
    let toStation = BehaviorSubject<TrainStation?>(value: nil)
    let fromStation = BehaviorSubject<TrainStation?>(value: nil)
    let directTrainRoutesSubject = BehaviorSubject<TrainRoutes?>(value: nil)
    let errorSubject = PublishRelay<Error>()
    let disposeBag = DisposeBag()
    
    let irishRailsApi: IrishRailApiServiceProtocol
    
    init(irishRailsApi: IrishRailApiServiceProtocol) {
        self.irishRailsApi = irishRailsApi
    }
}

extension TrainsSearchViewModel: TrainsSearchViewModelProtocol {

    var fromTrainStation: Driver<TrainStation?> {
        return fromStation.asDriver(onErrorJustReturn: nil)
    }
    
    var toTrainStation: Driver<TrainStation?> {
        return toStation.asDriver(onErrorJustReturn: nil)
    }
    
    var directTrainRoutes: Driver<TrainRoutes?> {
        return directTrainRoutesSubject.asDriver(onErrorJustReturn: nil)
    }
    
    var error: Driver<Error> {
        return errorSubject.asDriver(onErrorJustReturn: IrishRailApiError.unknownError)
    }
    
    func getTrainStations() {
        irishRailsApi.fetchAllStations().subscribe(onSuccess: { [weak self] (stations) in
            self?.trainStations.onNext(stations)
        }, onError: { [weak self] (err) in
            self?.errorSubject.accept(err)
        }).disposed(by: disposeBag)
    }
    
    func setFromStation(_ station: TrainStation) {
        fromStation.onNext(station)
    }
    
    func setToStation(_ station: TrainStation) {
        toStation.onNext(station)
    }
    
    func swapStations() {
        let from = try? fromStation.value()
        let to = try? toStation.value()
        
        fromStation.onNext(to)
        toStation.onNext(from)
    }
    
    func viewDidLoad() {
        let trainsForStation = fromStation.filterOutNull()
        .flatMap { [weak irishRailsApi] (station: TrainStation) -> Observable<TrainsForStation> in
            let api = irishRailsApi!
            // TODO: set minutes as parameter
            let trainsObs = api.fetchTrainsForStation(station, forNextMinutes: 90)
            return Observable<TrainsForStation>.combineLatest(Observable.just(station),
                                                              trainsObs.asObservable()) { (station, trains) in
                return TrainsForStation(trainStation: station, trains: trains)
            }
        }
        
        let trainsMovements = trainsForStation
        .flatMap { [weak irishRailsApi] (obj) -> Single<([[TrainMovement]])> in
            let api = irishRailsApi!
            let movementsRequest = obj.trains.map {
                api.fetchTrainMovements($0)
            }
            
            return Single.zip(movementsRequest)
        }
        
        let departures = Observable.zip(trainsForStation,
                                        trainsMovements) { (obj: TrainsForStation, tMovements) -> TrainsForStation in
            obj.assignMovementsToTrains(tMovements)
            return obj
        }
        
        Observable.combineLatest(departures,
                                 toStation.filterOutNull()) {(dep, toStation) in
            return TrainsSearchViewModel.findDirectRoutes(dep, toStation: toStation)
        }.bind(to: directTrainRoutesSubject)
        .disposed(by: disposeBag)
    }
}

private extension TrainsSearchViewModel {
    static func findDirectRoutes(_ departing: TrainsForStation, toStation: TrainStation) -> TrainRoutes {
        
        var directTrains = [Train]()
        for train in departing.trains {
            for movement in train.trainMovement where
                movement.stationCode == toStation.code &&
                movement.trainStopsAtThisLocation() {
                directTrains.append(train)
                break
            }
        }
        
        return TrainRoutes(fromStation: departing.trainStation!,
                          toStation: toStation,
                          directTrains: directTrains)
    }
}

public extension Observable {
    func filterOutNull<T>() -> Observable<T> {
        return filterMap { (obj) -> FilterMap<T> in
            guard let obj = obj as? T else {
                return .ignore
            }
            
            return .map(obj)
        }
    }
}
