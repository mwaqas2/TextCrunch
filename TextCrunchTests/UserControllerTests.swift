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
        var testUser = UserModel(email: "testingemail@testing.com", pass:"password")
        var testUser2 = UserModel(email: "testingemail@testing.com", pass:"notarealpassword")
        var testUser3 = UserModel(email: "doesntexist@testing.com", pass:"password")
        var controller = UserController()
        var result : UserController.UCCode = controller.loginUser(testUser)
        XCTAssert(result == UserController.UCCode.LOGINSUCCESS, "User successful login test failed.")
        result = controller.loginUser(testUser2)
        XCTAssert(result == UserController.UCCode.LOGINFAIL_PASSWORD, "User wrong password login test failed.")
        result = controller.loginUser(testUser3)
        XCTAssert(result == UserController.UCCode.LOGINFAIL_NEXIST, "User account does not exist login test failed.")
    }
    
    func testCreateUserAccount(){
        var testUser = UserModel(email: "useraccountcreationtest@testing.com", pass: "password")
        var testUser2 = UserModel(email: "testingemail@testing.com", pass:"password1234")
        var controller = UserController()
        var result : UserController.UCCode = controller.createUserAccount(testUser)
        XCTAssert(result == UserController.UCCode.CREATESUCCESS , "Successful account creation test failed.")
        result = controller.createUserAccount(testUser2)
        XCTAssert(result == UserController.UCCode.CREATEFAIL_EMAILEXISTS, "Email taken account creation test failed.")
        
        //Clean up by removing the useraccountcreationtest@testing.com user from the database.
        var userToDelte = PFUser.logInWithUsername("useraccountcreationtest@testing.com", password: "password")
        userToDelte.delete()
    }
    
    func testGetCurrentUser(){
        var testPFUser = PFUser.logInWithUsername("testingemail@testing.com", password: "password")
        var controller = UserController()
        var testUser = controller.getCurrentUser()
        XCTAssert(testUser != nil, "Returned current user nil test failed.")
        XCTAssert(testUser?.accountId == (testPFUser.objectId), "Returned current user ID match test failed.")
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
