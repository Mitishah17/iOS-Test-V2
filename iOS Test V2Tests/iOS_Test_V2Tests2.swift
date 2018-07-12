//
//  iOS_Test_V2Tests2.swift
//  iOS Test V2
//
//  Created by Miti Shah on 7/11/18.
//  Copyright © 2018 Miti Shah. All rights reserved.
//


import XCTest
@testable import iOS_Test_V2

class iOS_Test_V2Tests2: XCTestCase {
    
    override func setUp() {
        super.setUp()
     
    }
    func test_title_is_SignUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signin = storyboard.instantiateViewController(withIdentifier: "SignInViewController")  as! SignInViewController
        let _ = signin.view
        XCTAssertEqual("Sign In", signin.title!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    
    
}
