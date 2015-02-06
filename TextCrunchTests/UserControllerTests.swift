//
//  UserControllerTests.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-02-04.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit
import XCTest

//import TextCrunch

class UserControllerTests: XCTestCase {
    
    var appDelegate: AppDelegate = AppDelegate()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoginUser(){
        
    }
    
    func testCreateUserAccount(){
        var testUser = UserModel(email: "testingemail@testing.com", pass: "password")
        var controller = UserController()
        var result : UserController.UCCode = controller.createUserAccount(testUser)
        println("test result: \(result.rawValue)")
        XCTAssert(result == UserController.UCCode.CREATESUCESS , "Account not created.")
    }
    
    func testGetCurrentUser(){
        
    }
    
    func testDelteUserAccount(){
        
    }
    
    func testLogoutUser(){
        
    }
    
    func testResetPassword(){
        
    }
    
    func testGetUsersSoldListings(){
        
    }
    
    func testGetUsersBoughtListings(){
        
    }
    
    
    func testGetUsersActiveListings(){
        
    }
    
    func testUpdateCurrentUser(){
        
    }

}
