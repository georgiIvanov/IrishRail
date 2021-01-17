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
    
    var trainStations: BehaviorSubject<[TrainStation]> { get }
    var error: Driver<Error> { get }
    
    func getTrainStations()
    func filterStationsByName(_ search: String)
}

class TrainsSearchViewModel {
    
    let trainStations = BehaviorSubject<[TrainStation]>(value: [])
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
    
    func filterStationsByName(_ search: String) {
        
    }
}
