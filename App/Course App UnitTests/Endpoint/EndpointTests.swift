//
//  EndpointTests.swift
//  Course App UnitTests
//
//  Created by Tomáš Duchoslav on 20.06.2024.
//

@testable import App_Course_Dev
import XCTest

final class EndpointTests: XCTestCase {
    
    enum MockEndpoint: Endpoint {
        case mockMethodGet
        case mockMethodPost
        case mockParameterGet
        
        var host: URL {
            URL(string: "hhtps://example.com")!
        }
        
        var path: String {
            "api/test/path"
        }
        
        var method: HTTPMethod {
            switch self {
            case .mockMethodGet, .mockParameterGet:
                    .get
            case .mockMethodPost:
                    .post
            }
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHTTPMethod() throws {
        guard let urlRequestGet = try? MockEndpoint.mockParameterGet.asURLRequest() else {
            XCTFail("Can't create url request")
            return
        }
        
        XCTAssert(urlRequestGet.httpMethod == HTTPMethod.get.rawValue, "good")
        
        guard let urlRequestPost = try? MockEndpoint.mockMethodPost.asURLRequest() else {
            XCTFail("Can't create url request")
            return
        }
        
        XCTAssert(urlRequestPost.httpMethod == HTTPMethod.post.rawValue, "good")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
