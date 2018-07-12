//
//  iOS_Test_V2Tests.swift
//  iOS Test V2Tests
//
//  Created by Miti Shah on 7/9/18.
//  Copyright © 2018 Miti Shah. All rights reserved.
//

import XCTest
@testable import iOS_Test_V2

class iOS_Test_V2Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
   
    }
    
    func test_title_is_Landing() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let landing = storyboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
        let _ = landing.view
        XCTAssertEqual("Landing", landing.title!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    
 
    
}
