//
//  NetworkError.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 30.09.2021.
//

import Foundation

enum NetworkError: Error {
    
    case problemWithURL
    case problemWithEncodingModel
    case userNeedToLoginAgain
    case problemWithDownloadingFile

}
