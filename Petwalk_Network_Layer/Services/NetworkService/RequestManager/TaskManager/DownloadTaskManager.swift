//
//  DownloadTaskManager.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 04.10.2021.
//

import Foundation
import UIKit

// MARK: - DownloadTaskManager
class DownloadTaskManager: TaskManagerProtocol {
    
    // MARK: - Private properties
    private var tasks: [String: URLSessionTask] = [:]
    
    // MARK: - Public properties
    
    // MARK: - Life cycle
    
    // MARK: - Private methods
    private func getPathToDocument(with urlDocument: URL, completion: @escaping RequestResult) {
        do {
            let data = try Data(contentsOf: urlDocument)
            completion(data, nil, nil)
        } catch {
            completion(nil, nil, error)
        }
        
    }
    
    // MARK: - Public methods
    func createTask(request: URLRequest,
                    session: URLSession,
                    requestID: String,
                    completion: @escaping RequestResult) {
        
        let task = session.downloadTask(with: request) { [weak self] url, response, error in
            self?.tasks[requestID] = nil
            guard error == nil,
                  let safeUrl = url
            else {
                completion(nil, response, error)
                return
            }
            self?.getPathToDocument(with: safeUrl, completion: completion)
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
