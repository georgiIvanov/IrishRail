//
//  AppDIContainer.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation
import Swinject

extension ServiceEntry {
    func single() {
        inObjectScope(.container)
    }
}

class AppDIContainer {
    static let container: Container = {
        return createContainer()
    }()
    
    private static func createContainer() -> Container {
        Container.loggingFunction = nil

        let container = Container()
        let assemblies: [Assembly] = [
            ViewControllerAssembly(),
            ViewModelAssembly(),
            ServiceAssembly()
        ]
        _ = Assembler(assemblies, container: container)
        return container
    }
}
