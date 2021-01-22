//
//  TrainsSearchViewModelTests.swift
//  IrishRailAPITests
//
//  Created by Voro on 20.01.21.
//

import XCTest
import Foundation
import RxSwift
import RxCocoa

@testable import IrishRailAPI

class TrainsSearchViewModelTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    let container = AppDIContainer.container

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchAllTrainStations() throws {
        let expectation = self.expectation(description: "Get all train stations.")
        let vm = container.resolve(TrainsSearchViewModelProtocol.self)!
        
        let trainStations = vm.fetchTrainStations()
        
        trainStations.filter {
            $0.count != 0
        }.subscribe { (trainStations) in
            XCTAssert(trainStations.count == 167)
            expectation.fulfill()
        } onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        } onCompleted: {
            XCTFail("Unexpected complete")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testGetSpecificTrainStations() throws {
        let expectation = self.expectation(description: "Get specific train stations.")
        let vm = container.resolve(TrainsSearchViewModelProtocol.self)!
        
        let trainStations = vm.fetchTrainStations()
        
        trainStations.filter {
            $0.count != 0
        }.subscribe { [weak vm] (trainStations) in
            guard let _ = vm?.getTrainStation(withName: "Shankill") else {
                XCTFail("Could not get existing train station")
                return
            }
            
            guard let _ = vm?.getTrainStation(withName: "Lurgan") else {
                XCTFail("Could not get existing train station")
                return
            }
            
            guard let _ = vm?.getTrainStation(withName: "Howth") else {
                XCTFail("Could not get existing train station")
                return
            }
            expectation.fulfill()
        } onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        } onCompleted: {
            XCTFail("Unexpected complete")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetToFromTrainStations() throws {
        let expectation = self.expectation(description: "Set to/from train stations.")
        let vm = container.resolve(TrainsSearchViewModelProtocol.self)!
        
        let trainStations = vm.fetchTrainStations()
        
        trainStations.filter {
            $0.count != 0
        }.subscribe { [weak vm] (trainStations) in
            guard let shankill = vm?.getTrainStation(withName: "Shankill") else {
                XCTFail("Could not get existing train station")
                return
            }
            
            guard let lurgan = vm?.getTrainStation(withName: "Lurgan") else {
                XCTFail("Could not get existing train station")
                return
            }
            
            vm?.setFromStation(shankill)
            vm?.setToStation(lurgan)
        } onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        } onCompleted: {
            XCTFail("Unexpected complete")
        }.disposed(by: disposeBag)
        
        
        vm.directTrainRoutes.drive { (route) in
            XCTAssert(route == nil)
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCreateTrainRoutes() throws {
        let expectation = self.expectation(description: "Create train routes object.")
        let vm = container.resolve(TrainsSearchViewModelProtocol.self)!
        
        vm.viewDidLoad()
        let trainStations = vm.fetchTrainStations()
        
        trainStations.filter {
            $0.count != 0
        }.subscribe { [weak vm] (trainStations) in
            guard let shankill = vm?.getTrainStation(withName: "Shankill") else {
                XCTFail("Could not get existing train station")
                return
            }
            
            guard let greystones = vm?.getTrainStation(withName: "Greystones") else {
                XCTFail("Could not get existing train station")
                return
            }
            
            vm?.setFromStation(shankill)
            vm?.setToStation(greystones)
        } onError: { (error) in
            XCTFail("Unexpected error: \(error)")
        } onCompleted: {
            XCTFail("Unexpected complete")
        }.disposed(by: disposeBag)
        
        vm.directTrainRoutes.drive { (routes) in
            guard let routes = routes else {
                return
            }
            
            XCTAssert(routes.directTrains.count == 1)
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2, handler: nil)
    }

}
