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
    func fetchTrainsForStation(_ station: TrainStation, forNextMinutes: Int) -> Single<[Train]>
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
    
    func fetchTrainsForStation(_ station: TrainStation, forNextMinutes: Int) -> Single<[Train]> {
        let maxMin = min(forNextMinutes, 90)
            
        return irishRailApi.rx.request(.trainsForStation(stationCode: station.code, minutes: maxMin))
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
        .mapXMLDocument({ (xml) -> [Train] in
            return try IrishRailApiService.parseTrains(xml)
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
        return try stationsArray.map { (element) -> TrainStation in
            let name = try element.select("StationDesc").text()
            let alias = try? element.select("StationAlias").text()
            let latitude: Double = try element.select("StationLatitude").valueAsDouble()
            let longitude: Double = try element.select("StationLongitude").valueAsDouble()
            let code = try element.select("StationCode").text()
            let stationId = try element.select("StationId").valueAsInt()
            
            return TrainStation(stationId: stationId,
                                name: name,
                                alias: alias,
                                latitude: latitude,
                                longitude: longitude,
                                code: code)
        }
    }
    
    static func parseTrains(_ xml: Document) throws -> [Train] {
        let trainsArray = try xml.select("ArrayOfObjStationData").select("objStationData").array()
        return try trainsArray.map({ (element) -> Train in
            let trainCode = try element.select("Traincode").text()
            let status = TrainStatus(string: try element.select("Status").text())
            let type = TrainType(type: try element.select("Traintype").text())
            let dueIn = try element.select("Duein").valueAsInt()
            let late = try element.select("Late").valueAsInt()
            let direction = try element.select("Direction").text()
            let trainDate = try element.select("Traindate").text()
            let scheduledArrival = try element.select("Scharrival").text()
            let expectedArrival = try element.select("Exparrival").text()
            let scheduledDeparture = try element.select("Schdepart").text()
            let expectedDeparture = try element.select("Expdepart").text()
            
            let lastLocation = try element.select("Lastlocation").text()
            let stationName = try element.select("Stationfullname").text()
            let stationCode = try element.select("Stationcode").text()
            
            return Train(trainCode: trainCode,
                         status: status,
                         type: type,
                         dueIn: dueIn,
                         late: late,
                         direction: direction,
                         trainDate: trainDate,
                         scheduledArrival: scheduledArrival,
                         expectedArrival: expectedArrival,
                         scheduledDeparture: scheduledDeparture,
                         expectedDeparture: expectedDeparture,
                         lastLocation: lastLocation,
                         stationName: stationName,
                         stationCode: stationCode)
        })
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
