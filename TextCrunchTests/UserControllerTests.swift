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
    
    var appDelegate: AppDelegate! = AppDelegate()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
        
    }
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    override func tearDown() {
        super.tearDown()
    }

    func testLoginUser(){
        var testPass = "password"
        var uuid = NSUUID().UUIDString
        var testUser = User(email: "testingemail+\(uuid)@testing.com")
        testUser.password = testPass
        testUser.signUp()

        var result = UserController.loginUser(testUser.email, password: testUser.password)
        XCTAssert(result.code == UserController.UCCode.LOGINSUCCESS, "User successful login test failed.")
        
        result = UserController.loginUser(testUser.email, password: "notarealpassword")
        XCTAssert(result.code == UserController.UCCode.LOGINFAIL_NEXIST, "User wrong password login test failed.")
        
        var fakeUser = User(email: "doesntexist@testing.com")
        result = UserController.loginUser(fakeUser.email, password: testPass)
        XCTAssert(result.code == UserController.UCCode.LOGINFAIL_NEXIST, "User account does not exist login test failed.")
        testUser.delete()
    }
    
    func testCreateUserAccount() {
        var uuid = NSUUID().UUIDString
        var testUser = User(email: "testingemail+\(uuid)@testing.com")
        var result = UserController.createUserAccount(testUser.email, password: "password")
        XCTAssert(result.code == UserController.UCCode.CREATESUCCESS , "Successful account creation test failed.")
        
        result = UserController.createUserAccount(testUser.email, password: "password")
        XCTAssert(result.code == UserController.UCCode.CREATEFAIL_EMAILEXISTS, "Email taken account creation test failed.")
        testUser.delete()
    }
    
    func testDeleteCurrentUserAccount(){
        var uuid = NSUUID().UUIDString
        var testUser = User(email: "testingemail+\(uuid)@testing.com")
        // persist user for deletion
        testUser.password = "password"
        testUser.signUp()
        PFUser.logInWithUsername(testUser.username, password: "password")
        
        var deletionResult = UserController.deleteCurrentUserAccount()
        XCTAssert(deletionResult == true, "Sucessful account deletion test failed.")
        
        deletionResult = UserController.deleteCurrentUserAccount()
        XCTAssert(deletionResult == false, "Failed account deletion test failed.")
    }
    
    func testLogoutCurrentUser(){
        var uuid = NSUUID().UUIDString
        var testUser = User(email: "testingemail+\(uuid)@testing.com")
        testUser.password = "password"
        testUser.signUp()
        
        PFUser.logInWithUsername(testUser.username, password: "password")
        var logoutResult = UserController.logoutCurrentUser()
        XCTAssert(logoutResult == true, "Successful account logout test failed.")
        testUser.delete()//Delete in order to prevent DB cluttering.
        
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
