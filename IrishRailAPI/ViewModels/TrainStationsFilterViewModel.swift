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
    func trainStation(atIndex index: Int) -> TrainStation?
    func viewDidLoad()
}

class TrainStationsFilterViewModel {
    var trainStations: BehaviorSubject<[TrainStation]>!
    var nameFilter = BehaviorSubject<String>(value: "")
    var filteredStationsSubject = BehaviorSubject<[TrainStation]>(value: [])
    
    let disposeBag = DisposeBag()
}

extension TrainStationsFilterViewModel: TrainStationsFilterViewModelProtocol {    
    var filteredStations: Driver<[TrainStation]> {
        return filteredStationsSubject.asDriver(onErrorJustReturn: [])
    }
    
    func filterByName(_ trainStationName: String) {
        nameFilter.onNext(trainStationName)
    }
    
    func trainStation(atIndex index: Int) -> TrainStation? {
        guard let data = try? filteredStationsSubject.value() else {
            return nil
        }
        
        guard index >= 0 && index < data.count else {
            return nil
        }
        
        return data[index]
    }
    
    func viewDidLoad() {
        let fObs: Observable<[TrainStation]> = Observable.combineLatest(trainStations,
                                                                        nameFilter) { (trainStations, nameFilter) in
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
        }
        
        fObs
        .bind(to: filteredStationsSubject)
        .disposed(by: disposeBag)
    }
}
