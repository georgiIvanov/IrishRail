//
//  ViewControllerAssembly.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation
import Swinject
import SwinjectStoryboard

class ViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.storyboardInitCompleted(TrainsSearchViewController.self) { (res, controller) in
            controller.viewModel = res.resolve(TrainsSearchViewModelProtocol.self)
            controller.timeTicker = res.resolve(TimeTickerProtocol.self)
        }
        
        container.storyboardInitCompleted(TrainStationsFilterViewController.self) { (res, controller) in
            controller.viewModel = res.resolve(TrainStationsFilterViewModelProtocol.self)
        }
        
        container.storyboardInitCompleted(TrainRouteViewController.self) { (res, controller) in
            controller.viewModel = res.resolve(TrainRouteViewModelProtocol.self)
        }
    }
}
