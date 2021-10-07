//
//  TestEndpoint.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 04.10.2021.
//

import Foundation
import UIKit

enum TestEndpoint: EndpointType {

    case getData
    case auth
    case getImage
    case postImage(userID: Int, parameters: Parameters?, media: [UploadDataModel]?)

    var baseURL: String {
        switch self {
        default :
            return "http://192.168.0.177:3000/api/v1"
        }
    }
    
    var path: String {
        switch self {
        case .getData:
            return "/users/"
        case .auth:
            return "/auth/login"
        case .getImage:
            return ""
        case .postImage(let userID, _, _):
            return "/users/\(userID)/avatar"
        }
    }
    
    var refreshPath: String? { "/auth/refresh" }
    
    var headers: [String : String] {
        ["content-type": "application/json",
         "Accept": "application/json"]
    }

    var method: RequestMethod {
        switch self {
        case .getData, .getImage:
            return .get
        case .auth, .postImage:
            return .post
        }
    }
    
    var task: RequestTask {
        switch self {

        case .getData, .getImage:
            return .request(queryItems: nil)

        case .auth:
            return .request(queryItems: nil)

        case .postImage(_, let parameters, let media):
            return .upload(parameters: parameters, media: media)
        }
    }

    var authorizationType: AuthorizationType? {
        switch self {

        case .auth:
            return .requestBody

        default:
            return .bearer
        }
         }

}
