//
//  APIManager.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 06.06.2024.
//

import Foundation
import os

final class APIManager: APIManaging {
    
    private let logger = Logger()
    
    func request<T>(_ endpoint: any Endpoint) async throws -> T where T : Decodable {
        let data = try await request(endpoint)
        let jsonDecoder = JSONDecoder()
        
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw NetworkingError.decodingFailed(error: error)
        }
    }
    
    func request(_ endpoint: Endpoint) async throws -> Data {
        let request: URLRequest = try endpoint.asURLRequest()
        
        logger.info("Request for \"\(request.description)\"")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.noHttpResponse
        }
        
        try checkStatusCode(httpResponse)
        
        let body = String(decoding: data, as: UTF8.self)
        logger.info("""
                    Response for \"\(request.description)\""
                    Status: \(httpResponse.statusCode)
                    Body:
                    \(body)
                    """)
        
        return data
        
    }
    
    func checkStatusCode(_ urlResponse: HTTPURLResponse) throws {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw NetworkingError.unacceptableStatusCode
        }
    }
}
