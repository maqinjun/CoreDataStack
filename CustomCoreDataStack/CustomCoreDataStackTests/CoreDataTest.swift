//
//  CoreDataTest.swift
//  CustomCoreDataStack
//
//  Created by maqj on 5/6/16.
//  Copyright © 2016 maqj. All rights reserved.
//

import XCTest
import CoreData

class CoreDataTest: XCTestCase {
    
    var coreDataStack: CoreDataStackTest!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        coreDataStack = CoreDataStackTest()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        coreDataStack = nil
    }
    
    func testData() -> Void {
        print("test data")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        XCTAssert(coreDataStack.model != nil)
        XCTAssert(coreDataStack.psc != nil)
        XCTAssert(coreDataStack.store != nil)
//        XCTAssert(coreDataStack.context != nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
