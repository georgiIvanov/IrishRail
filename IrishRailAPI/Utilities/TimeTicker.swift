//
//  TimeTicker.swift
//  IrishRailAPI
//
//  Created by Voro on 20.01.21.
//

import Foundation
import RxSwift
import RxCocoa

protocol TimeTickerProtocol {
    var timerHasStarted: Bool { get }
    var timeTick: Observable<()> { get }
    
    func startTimer(interval: TimeInterval)
    func stopTimer()
}

class TimeTicker {
    
    private var timer: Timer?
    private var qosOnTimer = DispatchQoS.QoSClass.userInitiated
    private let timerTickSubject = PublishSubject<()>()
    
    func startTimer(interval: TimeInterval = 1) {
        guard timer == nil else {
            return
        }
        
        DispatchQueue.global(qos: qosOnTimer).async {
            let timer = Timer.scheduledTimer(timeInterval: interval,
                                             target: self,
                                             selector: #selector(self.timerTick),
                                             userInfo: nil, repeats: true)
            self.timer = timer
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: RunLoop.Mode.default)
            runLoop.run()
            
        }
    }
    
    func stopTimer() {
        guard timer != nil else {
            return
        }
        
        DispatchQueue.global(qos: qosOnTimer).async {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @objc func timerTick() {
        DispatchQueue.main.async {
            self.timerTickSubject.onNext(())
        }
        
    }
}

extension TimeTicker: TimeTickerProtocol {
    var timerHasStarted: Bool {
        return timer != nil
    }
    
    var timeTick: Observable<()> {
        return timerTickSubject.asObservable()
    }
}
