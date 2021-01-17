//
//  TrainsSearchViewModel.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation
import RxSwift
import RxCocoa

protocol TrainsSearchViewModelProtocol: class {
    
    var trainStations: BehaviorSubject<[TrainStation]> { get }
    var error: Driver<Error> { get }
    
    func getTrainStations()
    func setFromStation(_ station: TrainStation)
    func setToStation(_ station: TrainStation)
}

class TrainsSearchViewModel {
    
    let trainStations = BehaviorSubject<[TrainStation]>(value: [])
    let toStation = BehaviorSubject<TrainStation?>(value: nil)
    let fromStation = BehaviorSubject<TrainStation?>(value: nil)
    let errorSubject = PublishRelay<Error>()
    let disposeBag = DisposeBag()
    
    let irishRailsApi: IrishRailApiServiceProtocol
    
    init(irishRailsApi: IrishRailApiServiceProtocol) {
        self.irishRailsApi = irishRailsApi
    }
}

extension TrainsSearchViewModel: TrainsSearchViewModelProtocol {

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
}
