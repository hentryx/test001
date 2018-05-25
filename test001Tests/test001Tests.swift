//
//  test001Tests.swift
//  test001Tests
//
//  Created by Henry Bautista on 22/03/18.
//  Copyright © 2018 Henry Bautista. All rights reserved.
//

import XCTest
@testable import test001

class test001Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceMapViewController() {
        self.measure {
            MapViewController.load()
        }
    }
    
    func testPerformanceDetailViewController(){
        self.measure {
            DetailViewController.load()
        }
    }
    
    func testPerformanceViewController(){
        self.measure {
            ViewController.load()
        }
    }
}
