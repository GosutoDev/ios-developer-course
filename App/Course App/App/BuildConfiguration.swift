//
//  Configuration.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 09.05.2024.
//

import Foundation

struct BuildConfiguration: Decodable {
    private enum CodingKeys: String, CodingKey {
        case imagesBaseURL = "API_IMAGES_BASE_URL"
        case jokesBaseURL = "API_JOKES_BASE_URL"
    }
    
    let jokesBaseURL: URL
    let imagesBaseURL: URL
}

extension BuildConfiguration {
    static let `default`: BuildConfiguration = {
        guard let propertyList = Bundle.main.infoDictionary else {
            fatalError("Unable to get property list.")
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: propertyList, options: []) else {
            fatalError("Unable to instantiate data from property list.")
        }
        
        let decoder = JSONDecoder()
        guard let configuration = try? decoder.decode(BuildConfiguration.self, from: data) else {
            fatalError("Unable to decode the Environment configuration file.")
        }
        
        return configuration
    }()
}
