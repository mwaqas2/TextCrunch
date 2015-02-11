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
    var controller: UserController = UserController()
    var testUser: PSUser = PSUser(email: "testingemail@testing.com")
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
        self.testUser = PSUser(email: "testingemail@testing.com")
    }
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    override func tearDown() {
        super.tearDown()
        
        if (self.testUser.isAuthenticated()) {
            self.testUser.delete()
        }
    }

    func testLoginUser(){
        
        // persist user for login test
        var testPass = "password"
        self.testUser.password = testPass
        self.testUser.signUp()
        
        var result : UserController.UCCode = self.controller.loginUser(testUser, password: testPass)
        XCTAssert(result == UserController.UCCode.LOGINSUCCESS, "User successful login test failed.")
        
        result = controller.loginUser(testUser, password: "notarealpassword")
        XCTAssert(result == UserController.UCCode.LOGINFAIL_PASSWORD, "User wrong password login test failed.")
        
        var fakeUser = PSUser(email: "doesntexist@testing.com")
        result = controller.loginUser(fakeUser, password: testPass)
        XCTAssert(result == UserController.UCCode.LOGINFAIL_NEXIST, "User account does not exist login test failed.")
    }
    
    func testCreateUserAccount() {

        var result : UserController.UCCode = self.controller.createUserAccount(self.testUser, password: "password")
        XCTAssert(result == UserController.UCCode.CREATESUCCESS , "Successful account creation test failed.")
        
        result = self.controller.createUserAccount(self.testUser, password: "password")
        XCTAssert(result == UserController.UCCode.CREATEFAIL_EMAILEXISTS, "Email taken account creation test failed.")
    }
    
    func testGetCurrentUser(){
        
        self.testUser.password = "password"
        self.testUser.signUp()
        
        var testPFUser = PFUser.logInWithUsername(self.testUser.email, password: "password")
        var testUser = self.controller.getCurrentUser()
        
        XCTAssert(testUser != nil, "Returned current user nil test failed.")
        XCTAssert(testUser.objectId == testPFUser?.objectId, "Returned current user ID match test failed.")
    }
    
    func testDeleteCurrentUserAccount(){
        
        // persist user for deletion
        self.testUser.password = "password"
        self.testUser.signUp()
        PFUser.logInWithUsername(self.testUser.username, password: "password")
        
        var deletionResult = self.controller.deleteCurrentUserAccount()
        XCTAssert(deletionResult == true, "Sucessful account deletion test failed.")
        
        deletionResult = self.controller.deleteCurrentUserAccount()
        XCTAssert(deletionResult == false, "Failed account deletion test failed.")
    }
    
    func testLogoutCurrentUser(){
        
        self.testUser.password = "password"
        self.testUser.signUp()
        
        PFUser.logInWithUsername(self.testUser.username, password: "password")
        var logoutResult = self.controller.logoutCurrentUser()
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
