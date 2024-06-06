//
//  ImagesRouter.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 06.06.2024.
//

import Foundation

enum ImagesRouter: Endpoint {
    case size300x200
    
    var host: URL {
        BuildConfiguration.default.imagesBaseURL
    }
    
    var path: String {
        "300/200"
    }
}
