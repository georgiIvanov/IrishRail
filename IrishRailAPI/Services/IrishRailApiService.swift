//
//  IrishRailApiService.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation

protocol IrishRailApiServiceProtocol {
    func fetchAllStations()
}

class IrishRailApiService {
    let irishRailApi: IrishRailApi
    let dateFormatter: DateFormatter
    
    init(irishRailApi: IrishRailApi) {
        self.irishRailApi = irishRailApi
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd MM yyy"
    }
}

extension IrishRailApiService: IrishRailApiServiceProtocol {
    func fetchAllStations() {
        irishRailApi.rx.request(.allStations).subscribe { (resp) in
            let respStr = String(data: resp.data, encoding: .utf8)
            print(respStr)
        } onError: { (err) in
            print(err)
        }

    }
}
