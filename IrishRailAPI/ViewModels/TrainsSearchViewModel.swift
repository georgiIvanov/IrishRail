//
//  TrainsSearchViewModel.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation
import RxSwift
import RxCocoa

protocol TrainsSearchViewModelProtocol {
    
    var trainStations: Driver<[TrainStation]> { get }
    var error: Driver<Error> { get }
    
    func getTrainStations()
}

class TrainsSearchViewModel {
    
    let trainStationsSubject = BehaviorSubject<[TrainStation]>(value: [])
    let errorSubject = PublishRelay<Error>()
    let disposeBag = DisposeBag()
    
    let irishRailsApi: IrishRailApiServiceProtocol
    
    init(irishRailsApi: IrishRailApiServiceProtocol) {
        self.irishRailsApi = irishRailsApi
    }
}

extension TrainsSearchViewModel: TrainsSearchViewModelProtocol {
    
    var trainStations: Driver<[TrainStation]> {
        return trainStationsSubject.asDriver(onErrorJustReturn: [])
    }
    
    var error: Driver<Error> {
        return errorSubject.asDriver(onErrorJustReturn: IrishRailApiError.unknownError)
    }
    
    func getTrainStations() {
        irishRailsApi.fetchAllStations().subscribe(onSuccess: { [weak self] (stations) in
            self?.trainStationsSubject.onNext(stations)
        }, onError: { [weak self] (err) in
            self?.errorSubject.accept(err)
        }).disposed(by: disposeBag)
    }
}
