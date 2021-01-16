//
//  IrishRailApiService.swift
//  IrishRailAPI
//
//  Created by Voro on 15.01.21.
//

import Foundation
import RxSwift
import SwiftSoup
import Moya

protocol IrishRailApiServiceProtocol {
    func fetchAllStations() -> Single<[TrainStation]>
}

class IrishRailApiService {
    let irishRailApi: IrishRailApi
    
    init(irishRailApi: IrishRailApi) {
        self.irishRailApi = irishRailApi
    }
}

extension IrishRailApiService: IrishRailApiServiceProtocol {
    func fetchAllStations() -> Single<[TrainStation]> {
        return irishRailApi.rx.request(.allStations)
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
        .mapXMLDocument({ (xml) -> [TrainStation] in
            return try IrishRailApiService.parseTrainStations(xml)
        })
        .observeOn(MainScheduler.asyncInstance)
    }
}

// MARK: - Object Mapping

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapXMLDocument<T>(_ closure: @escaping (Document) throws -> T) -> Single<T> {
        return map { (resp) -> T in
            guard let strResponse = String(data: resp.data, encoding: .utf8) else {
                throw MoyaError.stringMapping(resp)
            }

            do {
                let xml = try SwiftSoup.parse(strResponse)
                return try closure(xml)
            } catch {
                throw MoyaError.objectMapping(error, resp)
            }
        }

    }
}


private extension IrishRailApiService {
    static func parseTrainStations(_ xml: Document) throws -> [TrainStation] {
        
        let stationsArray = try xml.select("ArrayOfObjStation").select("objStation").array()
        return try stationsArray.map { (xmlElement) -> TrainStation in
            let name = try xmlElement.select("StationDesc").text()
            let alias = try? xmlElement.select("StationAlias").text()
            let latitude: Double = try xmlElement.select("StationLatitude").valueAsDouble()
            let longitude: Double = try xmlElement.select("StationLongitude").valueAsDouble()
            let code = try xmlElement.select("StationCode").text()
            let id = try xmlElement.select("StationId").valueAsInt()
            
            return TrainStation(stationId: id,
                                name: name,
                                alias: alias,
                                latitude: latitude,
                                longitude: longitude,
                                code: code)
        }
    }
}

extension Elements {
    func valueAsDouble() throws -> Double {
        let text = try self.text()
        
        guard let result = Double(text) else {
            throw IrishRailApiError.unexpectedValue(text, "Could not map value to Double.")
        }
        
        return result
    }
    
    func valueAsInt() throws -> Int {
        let text = try self.text()
        
        guard let result = Int(text) else {
            throw IrishRailApiError.unexpectedValue(text, "Could not map value to Int.")
        }
        
        return result
    }
}
