//
//  IrishRailEndpoint.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation
import Moya

typealias IrishRailApi = MoyaProvider<IrishRailEndpoint>

enum IrishRailEndpoint {
    case allStations
}

extension IrishRailEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: AppConfig.irishRailApiBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .allStations:
            return "getAllStationsXML"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .allStations:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
