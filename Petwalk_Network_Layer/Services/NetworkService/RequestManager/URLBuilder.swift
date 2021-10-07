//
//  URLBuilderManager.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 30.09.2021.
//

import Foundation

// MARK: - URLBuilder
class URLBuilderManager {
    
    // MARK: - Private properties
    
    // MARK: - Public properties
    
    // MARK: - Life cycle
    
    // MARK: - Private methods
    
    // MARK: - Public methods
    func appendQueryItems(url: URL, queryItems: [String: String]) -> URL? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { return nil }

        let query: [URLQueryItem] = queryItems.map { URLQueryItem(name: $0, value: $1 ) }
        components.queryItems?.append(contentsOf: query)
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return components.url
    }
}
