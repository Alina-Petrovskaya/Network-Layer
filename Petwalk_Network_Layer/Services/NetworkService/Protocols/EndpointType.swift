//
//  EndpointType.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 30.09.2021.
//

import Foundation

// MARK: - Protocol EndpointType
protocol EndpointType {

    /**
     Main URL address for all requests

     # Example #
     ```
     // http://www.example.com
     ```
     */
    var baseURL: String { get }
    
    /**
     The address of the resource on the web server
     
     # Example #
     ```
     /path/to/somewhere
     ```
     */
    var path: String { get }
    
    /**
     Path to get a new token
     
     # Example #
     ```
     /path/to/refresh
     ```
     */
    var refreshPath: String? { get }
    
    var headers: [String: String] { get }
    
    var method: RequestMethod { get }
    
    var task: RequestTask { get }
    
    /**
     Represents the authorization header to use for requests.
     */
    var authorizationType: AuthorizationType? { get }

}
