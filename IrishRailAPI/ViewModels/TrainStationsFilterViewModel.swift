//
//  TrainsFilterViewModel.swift
//  IrishRailAPI
//
//  Created by Voro on 17.01.21.
//

import Foundation
import RxSwift
import RxCocoa


protocol TrainStationsFilterViewModelProtocol {
    var trainStations: BehaviorSubject<[TrainStation]>! { get set }
    var filteredStations: Driver<[TrainStation]> { get }
    
    func filterByName(_ trainStationName: String)
}

class TrainStationsFilterViewModel {
    var trainStations: BehaviorSubject<[TrainStation]>!
    var nameFilterSubject = PublishSubject<String>()
}

extension TrainStationsFilterViewModel: TrainStationsFilterViewModelProtocol {    
    var filteredStations: Driver<[TrainStation]> {
        return Observable.combineLatest(trainStations, nameFilterSubject.startWith("")) { (trainStations, nameFilter) in
            guard nameFilter.isEmpty == false else {
                return trainStations
            }
            
            let result = trainStations.filter {
                if $0.name.range(of: nameFilter, options: .caseInsensitive) != nil {
                    return true
                } else if $0.alias?.range(of: nameFilter, options: .caseInsensitive) != nil {
                    return true
                } else {
                    return false
                }
            }
            
            return result
        }.asDriver(onErrorJustReturn: [])
    }
    
    func filterByName(_ trainStationName: String) {
        nameFilterSubject.onNext(trainStationName)
    }
}
