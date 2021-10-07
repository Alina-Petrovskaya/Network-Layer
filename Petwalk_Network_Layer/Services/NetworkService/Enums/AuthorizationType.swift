//
//  AuthorizationType.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 01.10.2021.
//

import Foundation

// MARK: - Enum AuthorizationType
/**
 An enum representing the autorization header
 */
public enum AuthorizationType {

    case basic
    case bearer
    case requestBody
    case custom(String)

    public var value: String {
        switch self {
        case .basic: return "Basic"
        case .bearer: return "Bearer"
        case .requestBody: return ""
        case .custom(let customValue): return customValue
        }
    }

}
