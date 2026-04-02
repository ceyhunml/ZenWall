//
//  ZenWallTests.swift
//  ZenWallTests
//
//  Created by Ceyhun Məmmədli on 06.01.26.
//

import XCTest
@testable import ZenWall

final class ZenWallTests: XCTestCase {
    
    let manager = RandomPhotosManager()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testRandomPhotoData() throws {
        manager.getRandomPhotos(count: 20) { data, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            XCTAssertEqual(data?.count, 20)
        }
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
