//
//  RefreshManager.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 04.10.2021.
//

import Foundation

// MARK: - RefreshProtocol
protocol RefreshProtocol {
    
    func refresh(_ endpoint: EndpointType,
                 request: URLRequest,
                 session: URLSession,
                 authService: AuthorisationProtocol,
                 completion: @escaping RequestResult)

}

// MARK: - RefreshManager
class RefreshManager: RefreshProtocol {

    // MARK: - typealias
    typealias IsGotNewToken = Bool

    // MARK: - Private properties
    private var taskManager: TaskManagerProtocol?

    // MARK: - Public properties
    
    // MARK: - Life cycle
    
    // MARK: - Private methods
    /**
     Get new token for requests
     
     - parameter from: url that consists of baseURL and refresh path
     - parameter authService: service thats allows to save token
     - parameter session: an object that coordinates a group of related, network data transfer tasks
     - parameter completion: result of getting new token
     */
    private func getToken(from url: URL,
                          _ endpoint: EndpointType,
                          authService: AuthorisationProtocol,
                          session: URLSession,
                          completion: @escaping (IsGotNewToken) -> Void) {
        let request     = URLRequest(url: url)
        let authRequest = authService.prepare(request, target: endpoint)

        let task = session.dataTask(with: authRequest) { data, responde, error in
            guard error == nil,
                  let data = data
            else {
                completion(false)
                return
            }
            
            authService.saveToken(from: data)
            completion(true)
        }

        task.resume()
    }

    private func getData(from request: URLRequest,
                         session: URLSession,
                         task: RequestTask,
                         completion: @escaping RequestResult) {
        switch task {
        case .downloadFile:
            taskManager = DownloadTaskManager()
            taskManager?.createTask(request: request, session: session,
                                    requestID: UUID().uuidString,
                                    completion: completion)

        case .upload(let parameters, let media):
            taskManager = UploadTaskManager(parameters: parameters, media: media)
            taskManager?.createTask(request: request, session: session,
                                    requestID: UUID().uuidString,
                                    completion: completion)
            
        default:
            let task = session.dataTask(with: request, completionHandler: completion)
            task.resume()
        }
    }

    // MARK: - Public methods
    func refresh(_ endpoint: EndpointType,
                 request: URLRequest,
                 session: URLSession = URLSession.shared,
                 authService: AuthorisationProtocol,
                 completion: @escaping RequestResult) {
        guard let stringPath = endpoint.refreshPath,
              let url = URL(string: endpoint.baseURL + stringPath)
        else {
            completion(nil, nil, NetworkError.userNeedToLoginAgain)
            return
        }

        getToken(from: url,
                 endpoint,
                 authService: authService,
                 session: session) { [weak self] isGotNewToken in
            guard isGotNewToken else {
                completion(nil, nil, NetworkError.userNeedToLoginAgain)
                return
            }

            let authRequest = authService.prepare(request, target: endpoint)
            self?.getData(from: authRequest,
                          session: session,
                          task: endpoint.task,
                          completion: completion)
        }

    }
    
}
