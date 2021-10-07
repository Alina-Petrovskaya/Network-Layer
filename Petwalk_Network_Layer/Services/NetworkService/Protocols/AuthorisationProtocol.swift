//
//  AuthorisationProtocol.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 02.10.2021.
//

import Foundation
import KeychainSwift

// MARK: - Typealiases
typealias TokenClosure = (Data) -> String?

// MARK: - AuthorisationProtocol
protocol AuthorisationProtocol {

    /**
     Closure sends data to decode, and waits for tokenString
     */
    var tokenClosure: TokenClosure { get }

    /**
     Prepare user token for request
     */
    func prepare(_ request: URLRequest, target: EndpointType) -> URLRequest

    func saveToken(from data: Data)

}

extension AuthorisationProtocol {

    func saveToken(from data: Data) {
        guard let token = tokenClosure(data) else { return }
        KeychainSwift().set(token,
                            forKey: KeyChainKeysConstant.token.rawValue,
                            withAccess: .accessibleWhenUnlocked)
    }
     
}
