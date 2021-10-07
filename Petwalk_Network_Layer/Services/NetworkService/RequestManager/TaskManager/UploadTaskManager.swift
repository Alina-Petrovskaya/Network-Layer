//
//  UploadTaskManager.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 04.10.2021.
//

import Foundation

// MARK: - UploadTaskManager
class UploadTaskManager: TaskManagerProtocol {
 
    // MARK: - Private properties
    private var tasks: [String: URLSessionTask] = [:]
    private let parameters: Parameters?
    private let media: [UploadDataModel]?

    // MARK: - Public properties
    
    // MARK: - Life cycle
    init(parameters: Parameters?, media: [UploadDataModel]?) {
        self.parameters = parameters
        self.media      = media
    }
    
    // MARK: - Private methods
    private func generateMultipartBody(request: inout URLRequest ) {
        let boundary      = BoundaryGenerator.randomBoundary()
        let finalBoundary = BoundaryGenerator.boundaryData(forBoundaryType: .final, boundary: boundary)
        var bodyData      = Data()

        bodyData.append(prepareParameters(for: boundary))
        bodyData.append(prepareMediaData(for: boundary))

        bodyData.append(finalBoundary)
 
        request.httpBody = bodyData
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
    }
    
    private func prepareMediaData(for boundary: String) -> Data {
        var mediaData = Data()
        guard let safeMedia = media else { return mediaData }
        let initialBoundary = BoundaryGenerator.boundaryData(forBoundaryType: .initial,boundary: boundary)

        safeMedia.forEach { media in
            mediaData.append(initialBoundary)
            mediaData.append(media.getDisposition())
            mediaData.append(media.getContentType())
            mediaData.append(media.fileData)
            mediaData.append(Separator.lineBreak.rawValue)
        }
        return mediaData
    }
    
    private func prepareParameters(for boundary: String) -> Data {
        var parametersData = Data()
        guard let safeParameters = parameters else { return parametersData }
        
        let initialBoundary = BoundaryGenerator.boundaryData(forBoundaryType: .initial, boundary: boundary)

        safeParameters.forEach { key, value in
            var disposition = "Content-Disposition: form-data; name \"\(key)\""
            disposition += Separator.lineBreak.rawValue
            disposition += Separator.lineBreak.rawValue

            parametersData.append(initialBoundary)
            parametersData.append(disposition)
            parametersData.append("\(value + Separator.lineBreak.rawValue)")
        }

        return parametersData
    }
    
    // MARK: - Public methods
    func createTask(request: URLRequest,
                    session: URLSession,
                    requestID: String,
                    completion: @escaping RequestResult) {
        var request = request
        generateMultipartBody(request: &request)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            self?.tasks[requestID] = nil
            completion(data, response, error)
        }

        tasks[requestID] = task
        task.resume()
    }
    
    func cancel() {
        tasks.forEach { _, value in
            value.cancel()
        }
    }
    
}
