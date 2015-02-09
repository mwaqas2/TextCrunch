//
//  UserControllerTests.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-02-04.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit
import XCTest

import TextCrunch

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
        var testUser = User(email: "testingemail@testing.com", pass:"password")
        var testUser2 = User(email: "testingemail@testing.com", pass:"notarealpassword")
        var testUser3 = User(email: "doesntexist@testing.com", pass:"password")
        var controller = UserController()
        var result : UserController.UCCode = controller.loginUser(testUser)
        XCTAssert(result == UserController.UCCode.LOGINSUCCESS, "User successful login test failed.")
        result = controller.loginUser(testUser2)
        XCTAssert(result == UserController.UCCode.LOGINFAIL_PASSWORD, "User wrong password login test failed.")
        result = controller.loginUser(testUser3)
        XCTAssert(result == UserController.UCCode.LOGINFAIL_NEXIST, "User account does not exist login test failed.")
    }
    
    func testCreateUserAccount(){
        var testUser = User(email: "useraccountcreationtest@testing.com", pass: "password")
        var testUser2 = User(email: "testingemail@testing.com", pass:"password1234")
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
    
    func testDelteCurrentUserAccount(){
        //Set up by creating a new user account that will be deleted.
        var newUser = PFUser()
        var controller = UserController()
        newUser.email = "accounttodelete@testing.com"
        newUser.password = "password"
        newUser.username = "accounttodelete@testing.com"
        var signupResult = newUser.signUp()
        XCTAssert(signupResult == true, "Account deletion test setup failed.")
        
        var deletionResult = controller.deleteCurrentUserAccount()
        XCTAssert(deletionResult == true, "Sucessful account deletion test failed.")
        
        deletionResult = controller.deleteCurrentUserAccount()
        XCTAssert(deletionResult == false, "Failed account deletion test failed.")
    }
    
    func testLogoutCurrentUser(){
        PFUser.logInWithUsername("testingemail@testing.com", password: "password")
        var controller = UserController()
        var logoutResult = controller.logoutCurrentUser()
        XCTAssert(logoutResult == true, "Successful account logout test failed.")
        
    }
    
    func testResetPassword(){
        //Untestable programmatically since it requires the user to respond to an email.
    }
    
    func testGetUsersSoldListings(){
        
    }
    
    func testGetUsersBoughtListings(){
        
    }
    
    
    func testGetUsersActiveListings(){
        
    }
    

}
