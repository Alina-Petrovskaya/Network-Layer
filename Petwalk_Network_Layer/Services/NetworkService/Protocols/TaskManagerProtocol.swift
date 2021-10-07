//
//  TaskManagerProtocol.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 04.10.2021.
//

import Foundation

// MARK: - TaskManagerProtocol
protocol TaskManagerProtocol {
    /**
     Creating Task on data requesting
     
     - parameter request: configured request
     - parameter request: string id to find task and control it
     - parameter completion: result of data requesting
     */
    func createTask(request: URLRequest,
                    session: URLSession,
                    requestID: String,
                    completion: @escaping RequestResult)

    func cancel()

}
