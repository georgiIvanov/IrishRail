//
//  MessageLabel.swift
//  IrishRailAPI
//
//  Created by Voro on 21.01.21.
//

import UIKit

class MessageLabel: UILabel {

    var error: Error?
    
    var isPresentingError: Bool {
        return error != nil
    }
    
    func present(_ textToShow: String) {
        error = nil
        text = textToShow
    }
    
    func present(_ error: Error) {
        self.error = error
        text = error.localizedDescription
    }

}
