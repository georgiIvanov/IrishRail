//
//  ServiceAssembly.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation
import Swinject
import Moya
import Alamofire

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        registerIrishRailsApiProvider(into: container)
        
        container.register(IrishRailApiServiceProtocol.self) { (res) in
            return IrishRailApiService(irishRailApi: res.resolve(IrishRailApi.self)!)
        }
        
        container.register(TimeTickerProtocol.self) { (_) in
            return TimeTicker()
        }
    }
}

private extension ServiceAssembly {
    func registerIrishRailsApiProvider(into container: Container) {
        container.register(IrishRailApi.self) { _ in
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            configuration.requestCachePolicy = .useProtocolCachePolicy

            let manager = Session.init(configuration: configuration)

            if AppConfig.stubResponses {
                return IrishRailApi(stubClosure: IrishRailApi.delayedStub(0.1),
                                      session: manager)
            } else {
                return IrishRailApi(session: manager)
            }
        }.single()
    }
}
