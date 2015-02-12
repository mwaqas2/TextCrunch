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
    
    var appDelegate: AppDelegate!
    var controller: UserController!
    var testUser: User!
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        
        appDelegate = AppDelegate()
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
        controller = UserController()
        
        // generate uuid's so we don't have collisions and for test debugging
        var uuid = NSUUID().UUIDString
        testUser = User(email: "testingemail+\(uuid)@testing.com")
        
        // uncomment the print statement to help with debugging
        // println(testUser.email)
    }
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    override func tearDown() {
        super.tearDown()
        
        if (self.testUser.isAuthenticated()) {
            // comment this out if you need to debug the post test state
            testUser.delete()
        }
    }

    func testLoginUser(){
        
        // persist user for login test
        var testPass = "password"
        
        self.testUser.password = testPass
        self.testUser.signUp()

        var result = self.controller.loginUser(testUser, password: self.testUser.password)
        XCTAssert(result.code == UserController.UCCode.LOGINSUCCESS, "User successful login test failed.")
        
        result = controller.loginUser(testUser, password: "notarealpassword")
        XCTAssert(result.code == UserController.UCCode.LOGINFAIL_NEXIST, "User wrong password login test failed.")
        
        var fakeUser = User(email: "doesntexist@testing.com")
        result = controller.loginUser(fakeUser, password: testPass)
        XCTAssert(result.code == UserController.UCCode.LOGINFAIL_NEXIST, "User account does not exist login test failed.")
    }
    
    func testCreateUserAccount() {

        var result = self.controller.createUserAccount(testUser, password: "password")
        XCTAssert(result.code == UserController.UCCode.CREATESUCCESS , "Successful account creation test failed.")
        
        result = self.controller.createUserAccount(testUser, password: "password")
        XCTAssert(result.code == UserController.UCCode.CREATEFAIL_EMAILEXISTS, "Email taken account creation test failed.")
    }
    
    func testDeleteCurrentUserAccount(){
        
        // persist user for deletion
        testUser.password = "password"
        testUser.signUp()
        PFUser.logInWithUsername(testUser.username, password: "password")
        
        var deletionResult = controller.deleteCurrentUserAccount()
        XCTAssert(deletionResult == true, "Sucessful account deletion test failed.")
        
        deletionResult = controller.deleteCurrentUserAccount()
        XCTAssert(deletionResult == false, "Failed account deletion test failed.")
    }
    
    func testLogoutCurrentUser(){
        
        testUser.password = "password"
        testUser.signUp()
        
        PFUser.logInWithUsername(testUser.username, password: "password")
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
