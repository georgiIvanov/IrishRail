//
//  ViewModelAssembly.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation
import Swinject

class ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        container.register(TrainsSearchViewModelProtocol.self) { (res) in
            return TrainsSearchViewModel(irishRailsApi: res.resolve(IrishRailApiServiceProtocol.self)!)
        }
        
        container.register(TrainStationsFilterViewModelProtocol.self) { _ in
            return TrainStationsFilterViewModel()
        }
        
        container.register(TrainRouteViewModelProtocol.self) { _ in
            return TrainRouteViewModel()
        }
    }
}
