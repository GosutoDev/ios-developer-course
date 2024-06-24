//
//  KeychainServiceTests.swift
//  Course App UnitTests
//
//  Created by Tomáš Duchoslav on 20.06.2024.
//

@testable import App_Course_Dev
import XCTest

final class KeychainServiceTests: XCTestCase {
    
    var mockKeychainManager: MockKeychainManager!
    var keychainService: KeychainService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockKeychainManager = MockKeychainManager()
        keychainService = KeychainService(keychainManager: mockKeychainManager)
    }
    
    override func tearDownWithError() throws {
        mockKeychainManager = nil
        keychainService = nil
        try super.tearDownWithError()
    }
    
    func testStoreAuthData() throws {
        try keychainService.storeAuthData(authData: "12345")
        XCTAssert(try mockKeychainManager.keychain.contains("com.course.app.authData"))
        
        try keychainService.removeAuthData()
        XCTAssert(try !mockKeychainManager.keychain.contains("com.course.app.authData"))
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
