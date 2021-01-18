//
//  Data+Extensions.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation

extension Data {
    static func xmlData(fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "xml") else {
            return nil
        }
        
        let url = URL(string: "file://\(path)")!
        let data = try? Data(contentsOf: url)
        return data
    }
}
