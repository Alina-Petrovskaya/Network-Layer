//
//  NetworkManager.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 01.10.2021.
//

import Foundation

// MARK: - Typealias
typealias RequestResult   = (Data?, URLResponse?, Error?) -> Void

// MARK: - NetworkManager
class NetworkManager<EndPoint: EndpointType> {
    
    // MARK: - Private properties
    private let session: URLSession
    private let authService: AuthorisationProtocol?
    private var tasksManagers: [String: TaskManagerProtocol] = [:]
    private let requestBuilder: RequestBuilderProtocol
    private let refreshManager: RefreshProtocol

    // MARK: - Public properties
    
    // MARK: - Life cycle
    init(authService: AuthorisationProtocol? = nil,
         sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default,
         requestBuilder: RequestBuilderProtocol = RequestBuilderManager(),
         refreshManager: RefreshProtocol = RefreshManager()) {
        self.authService    = authService
        self.requestBuilder = requestBuilder
        self.refreshManager = refreshManager

        sessionConfiguration.timeoutIntervalForRequest = 30
        self.session     = URLSession(configuration: sessionConfiguration)
    }
    
    // MARK: - Private methods
    private func generateRequestManager(for task: RequestTask) -> String {
        var requestID = UUID().uuidString
        while (tasksManagers[requestID] != nil) {
            requestID = UUID().uuidString
        }
        
        switch task {
        case .request, .requestEncoding:
            tasksManagers[requestID] = GetTaskManager()

        case .downloadFile:
            tasksManagers[requestID] = DownloadTaskManager()
            
        case .upload(let parameters, let media):
            tasksManagers[requestID] = UploadTaskManager(parameters: parameters,
                                                         media: media)
        }

        return requestID
    }

    private func createTask(_ endpoint: EndPoint, completion: @escaping RequestResult) {
        let requestID = generateRequestManager(for: endpoint.task)
        
        do {
            let request     = try requestBuilder.buildURLRequest(with: endpoint)
            let authRequest = authService?.prepare(request, target: endpoint)
            tasksManagers[requestID]?.createTask(request: authRequest ?? request,
                                                 session: session,
                                                 requestID: requestID) { [weak self] data, response, error in
                print("""
                       First respond
                       =====
                       Data:
                       \(data)
                       ======
                       
                       Response
                       \(response)
                       =========
                       
                       Error
                       \(error)
                       ========
                       """)
                
                self?.tasksManagers[requestID] = nil
                if (response as? HTTPURLResponse)?.statusCode == 401 {
                    guard let self = self,
                          let safeAuthService = self.authService
                    else { completion(data, response, error); return }
                    self.refreshManager.refresh(endpoint,
                                                request: request,
                                                session: self.session,
                                                authService: safeAuthService,
                                                completion: completion)
                } else {
                    if let data = data  {
                        self?.authService?.saveToken(from: data)
                    }
                    completion(data, response, error)
                }
            }

        } catch {
            completion(nil, nil, error)
        }
    }
    
    // MARK: - Public methods
    func request(_ endpoint: EndPoint,
                 completion: @escaping RequestResult) {
        createTask(endpoint, completion: completion)
    }

    func request<D: Decodable>(_ endpoint: EndPoint,
                               decodableModel: D.Type,
                               completion: @escaping (Result<D, Error>) -> Void) {
        
        createTask(endpoint) { data, response, error in
            guard error == nil,
                  let data = data
            else {
                completion(.failure(error!))
                return
            }
            guard let decodedData = try? data.decode(with: decodableModel)
            else {
                print("Can't decode data")
                return
            }
            completion(.success(decodedData))
        }
    }

    func cancel() {
        tasksManagers.forEach { $1.cancel() }
        tasksManagers.removeAll()
    }

}
