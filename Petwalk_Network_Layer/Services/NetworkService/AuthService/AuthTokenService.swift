//
//  AuthTokenService.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 02.10.2021.
//

import Foundation
import KeychainSwift

// MARK: - AuthTokenService
class AuthTokenService: AuthorisationProtocol {
    
    // MARK: - Private properties
    
    // MARK: - Public properties
    var tokenClosure: TokenClosure

    // MARK: - Life cycle
    init(tokenClosure: @escaping TokenClosure) {
        self.tokenClosure = tokenClosure
    }

    // MARK: - Private methods
    private func getToken() -> String? {
       return KeychainSwift().get(KeyChainKeysConstant.token.rawValue)
    }

    // MARK: - Public methods
    func prepare(_ request: URLRequest, target: EndpointType) -> URLRequest {
        guard let authorizationType = target.authorizationType?.value,
              let token = getToken()
        else { return request }

        var request        = request
        let authValue      = authorizationType + " " + "\(token)"
        request.addValue(authValue, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
}
