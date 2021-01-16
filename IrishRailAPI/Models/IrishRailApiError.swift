//
//  IrishRailApiError.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation

typealias ApiErrorMessage = String
enum IrishRailApiError: Error {
    case unknownError
    case unexpectedValue(String, ApiErrorMessage)
}
