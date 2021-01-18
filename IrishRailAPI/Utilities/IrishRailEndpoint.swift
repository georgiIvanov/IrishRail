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
    case trainsForStation(stationCode: String, minutes: Int)
    case trainMovements(trainCode: String, trainDate: String)
}

extension IrishRailEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: AppConfig.irishRailApiBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .allStations:
            return "getAllStationsXML"
        case .trainsForStation:
            return "getStationDataByCodeXML_WithNumMins"
        case .trainMovements:
            return "getTrainMovementsXML"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .allStations:
            return Data.xmlData(fileName: "AllStations")!
        case .trainsForStation, .trainMovements:
            // TODO: Add mock data
            fatalError("No data")
        }
    }
    
    var task: Task {
        switch self {
        case .allStations:
            return .requestPlain
        case .trainsForStation(let stationCode, let minutes):
            let params: [String: Any] = [
                "StationCode": stationCode,
                "NumMins": minutes
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .trainMovements(let trainCode, let trainDate):
            let params: [String: Any] = [
                "TrainId": trainCode,
                "TrainDate": trainDate
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
