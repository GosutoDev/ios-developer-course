//
//  JokeServiceTests.swift
//  Course App UnitTests
//
//  Created by Tomáš Duchoslav on 20.06.2024.
//

@testable import App_Course_Dev
import XCTest

final class JokeServiceTests: XCTestCase {
    
    var mockApiManager: MockAPIManager!
    var jokeService: JokeService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApiManager = MockAPIManager()
        jokeService = JokeService(apiManager: mockApiManager)
    }

    override func tearDownWithError() throws {
        mockApiManager = nil
        jokeService = nil
        try super.tearDownWithError()
    }

    func testFetchCategories() async throws {
        mockApiManager.mockData = MockDataResponses.mockCategoriesResponse
        let categories = try await jokeService.loadCategories()
        XCTAssert(categories.count == 2, "good")
        XCTAssert(categories.contains(where: { $0 == "funny" }))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
