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

    func testGetAllTrainStations() throws {
        let expectation = self.expectation(description: "Get all train stations.")
        
        let vm = container.resolve(TrainsSearchViewModelProtocol.self)!
        
        vm.getTrainStations()
        
        vm.trainStations.filter {
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

}
