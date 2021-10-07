//
//  GetTaskManager.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 04.10.2021.
//

import Foundation

// MARK: - GetTaskManager
class GetTaskManager: TaskManagerProtocol {

    // MARK: - Private properties
    private var tasks: [String: URLSessionTask] = [:]

    // MARK: - Public properties
    
    // MARK: - Life cycle
    
    // MARK: - Private methods
    
    // MARK: - Public methods
    func createTask(request: URLRequest,
                    session: URLSession,
                    requestID: String,
                    completion: @escaping RequestResult) {
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                self?.tasks[requestID] = nil
                completion(data, response, error)
            }

            tasks[requestID] = task
            task.resume()
    }

    func cancel() {
        tasks.forEach { key, value in
            value.cancel()
        }
    }

}
