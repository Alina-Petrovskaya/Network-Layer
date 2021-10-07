//
//  Data + String.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 06.10.2021.
//

import Foundation

extension Data {

   mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }

}
