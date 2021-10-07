//
//  RequestTask.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 01.10.2021.
//

import Foundation

// MARK: - Typealias
typealias Parameters = [String: String]
typealias QueryItems = [String: String]

// MARK: - Enum RequestTask
enum RequestTask {

    case request(queryItems: QueryItems?)
    
    case requestEncoding(queryItems: QueryItems?, model: Encodable)
    
    case downloadFile(queryItems: QueryItems?)
    
    case upload(parameters: Parameters?, media: [UploadDataModel]?)

}
