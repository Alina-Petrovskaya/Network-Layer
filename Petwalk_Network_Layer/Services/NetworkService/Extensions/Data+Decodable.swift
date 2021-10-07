//
//  Data+Decodable.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 06.10.2021.
//

import Foundation

extension Data {
    
    func decode<T: Decodable>(with model: T.Type) throws -> T {
        do {
            let data = try JSONDecoder().decode(model, from: self)
            return data
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
}
