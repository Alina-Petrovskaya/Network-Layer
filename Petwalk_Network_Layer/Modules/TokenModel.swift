//
//  TokenModel.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 02.10.2021.
//

import Foundation

struct TokenModel: Codable {
    
    let data: DataDetail
    
}

struct DataDetail: Codable {
    let id: Int
    let token: String
}
