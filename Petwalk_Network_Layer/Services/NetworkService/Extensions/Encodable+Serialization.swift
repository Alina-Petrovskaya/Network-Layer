//
//  Encodable+Serialization.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 01.10.2021.
//

import Foundation

extension Encodable {
    
    func encode(bodyOf urlRequest: inout URLRequest) throws {
        do {
            let encodedData     = try JSONEncoder().encode(self)
            urlRequest.httpBody = encodedData
        }
        catch {
            throw NetworkError.problemWithEncodingModel
        }
    }
    
    func encode() throws -> Data {
        do {
           return try JSONEncoder().encode(self)
        }
        catch {
            throw NetworkError.problemWithEncodingModel
        }
    }
    
}
