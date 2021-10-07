//
//  Autorization.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 02.10.2021.
//

import Foundation
import KeychainSwift

// MARK: - Authorisation
class Authorisation: AuthorisationProtocol {
    
    // MARK: - Private properties
    private let assetModel: UserAssetsModel
    
    // MARK: - Public properties
    var tokenClosure: TokenClosure

    // MARK: - Life cycle
    init(assetModel: UserAssetsModel, tokenClosure: @escaping TokenClosure) {
        self.assetModel   = assetModel
        self.tokenClosure = tokenClosure
    }
    
    // MARK: - Private methods
    
    // MARK: - Public methods
    func prepare(_ request: URLRequest, target: EndpointType) -> URLRequest {
        guard let authType = target.authorizationType else { return request }
        var request        = request

        switch authType {
        case .requestBody:
            try? assetModel.encode(bodyOf: &request)
            return request

        default:
            guard let loginData = ("\(assetModel.email):\(assetModel.password)")
                    .data(using: .utf8)
            else { return request }

            let encodedAuthInfo = loginData.base64EncodedString()
            let authValue       = authType.value + " " + "\(encodedAuthInfo)"
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
            return request
        }
    }

}
