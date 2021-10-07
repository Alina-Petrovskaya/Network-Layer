//
//  BoundaryGenerator.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 06.10.2021.
//

import Foundation

// MARK: - Separator
enum Separator: String {
    
    case lineBreak = "\r\n"

}

// MARK: - BoundaryGenerator
enum BoundaryGenerator {

    // MARK: - BoundaryType
    enum BoundaryType {
        case initial, encapsulated, final
    }

    // MARK: - Static methods
    static func randomBoundary() -> String {
        let first = UInt32.random(in: UInt32.min...UInt32.max)
        let second = UInt32.random(in: UInt32.min...UInt32.max)

        return String(format: "boundary.%08x%08x", first, second)
    }

    static func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
        let boundaryText: String

        switch boundaryType {
        case .initial:
            boundaryText = "--\(boundary)\(Separator.lineBreak.rawValue)"

        case .encapsulated:
            boundaryText = "\(Separator.lineBreak.rawValue)--\(boundary)\(Separator.lineBreak.rawValue)"

        case .final:
            boundaryText = "\(Separator.lineBreak.rawValue)--\(boundary)--\(Separator.lineBreak.rawValue)"
        }

        return Data(boundaryText.utf8)
    }
}
