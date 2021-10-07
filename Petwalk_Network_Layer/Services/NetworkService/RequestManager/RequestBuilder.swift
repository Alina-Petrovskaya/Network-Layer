//
//  RequestBuilderManager.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 30.09.2021.
//

import UIKit

// MARK: - RequestBuilderProtocol
protocol RequestBuilderProtocol {

    func buildURLRequest(with endPoint: EndpointType) throws -> URLRequest

}

// MARK: - RequestBuilderManager
class RequestBuilderManager: RequestBuilderProtocol {

    // MARK: - Private properties

    // MARK: - Public properties

    // MARK: - Life cycle

    // MARK: - Private methods
    private func modify(_ request: inout URLRequest, with url: URL, task: RequestTask) throws {
        switch task {
        case .request(let queryItems), .downloadFile(let queryItems):
            guard let queryItems = queryItems else { return }
            let newURL = URLBuilderManager().appendQueryItems(url: url,
                                                              queryItems: queryItems)
            request.url = newURL

        case .requestEncoding(let queryItems, let model):
            if let safeQuery = queryItems {
                let newURL = URLBuilderManager().appendQueryItems(url: url,
                                                                  queryItems: safeQuery)
                request.url = newURL
            }

            do {
                try model.encode(bodyOf: &request)
            } catch {
                throw NetworkError.problemWithEncodingModel
            }
            
        case .upload:
           break
        }
    }

    // MARK: - Public methods
    func buildURLRequest(with endPoint: EndpointType) throws -> URLRequest {
        guard let safeURL = URL(string: (endPoint.baseURL + endPoint.path))
        else {
            throw NetworkError.problemWithURL
        }

        var request                 = URLRequest(url: safeURL)
        request.httpMethod          = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.headers

        do {
            try modify(&request, with: safeURL, task: endPoint.task)
        } catch {
            throw error
        }

        return request
    }

}
