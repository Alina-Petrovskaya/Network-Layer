//
//  UploadImageModel.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 06.10.2021.
//

import UIKit

// MARK: - UploadDataModel

struct UploadDataModel {

    // MARK: - Private properties
    /**
     Name(key) of field in witch located file
     */
    private let name: String
    private let mimeType: MimeType
    private let fileName: String
    
    // MARK: - Public properties
    let fileData: Data

    // MARK: - Life cycle
    init(name: String, mimeType: MimeType, fileName: String, fileData: Data) {
        self.name     = name
        self.mimeType = mimeType
        self.fileName = fileName
        self.fileData = fileData
    }

    // MARK: - Private methods

    // MARK: - Public methods
    func getDisposition() -> String {
        var disposition = "Content-Disposition: form-data; name=\"\(name)\""
        disposition    += "; filename=\"\(fileName)\""
        disposition    += Separator.lineBreak.rawValue
        return disposition
    }

    func getContentType() -> String {
        var contentType = "Content-Type: \(mimeType.rawValue)"
        contentType += Separator.lineBreak.rawValue + Separator.lineBreak.rawValue
        return contentType
    }
    
}
