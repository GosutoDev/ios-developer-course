//
//  MockAPIManager.swift
//  Course App UnitTests
//
//  Created by Tomáš Duchoslav on 20.06.2024.
//

@testable import App_Course_Dev
import Foundation

enum MockError: Error {
    case noMockDataError
}

final class MockAPIManager: APIManaging {
    var apiError: NetworkingError?
    var mockData: Data?
    
    func request<T>(_ endpoint: any Endpoint) async throws -> T where T : Decodable {
        if let apiError{
            throw apiError
        }
        
        if let data = mockData {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } else {
            throw MockError.noMockDataError
        }
    }
}
