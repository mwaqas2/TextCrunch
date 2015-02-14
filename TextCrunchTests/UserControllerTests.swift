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
        //testUser.delete()
    }
    
    func testCreateUserAccount() {
        var uuid = NSUUID().UUIDString
        var testUser = User(email: "testingemail+\(uuid)@testing.com")
        var result = UserController.createUserAccount(testUser.email, password: "password")
        XCTAssert(result.code == UserController.UCCode.CREATESUCCESS , "Successful account creation test failed.")
        
        result = UserController.createUserAccount(testUser.email, password: "password")
        XCTAssert(result.code == UserController.UCCode.CREATEFAIL_EMAILEXISTS, "Email taken account creation test failed.")
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
    }
    
    func testResetPassword(){
        //Untestable programmatically since it requires the user to respond to an email.
    }
    
    func testGetUsersSoldListings(){
        var uuid = NSUUID().UUIDString
        var testUser = User(email: "testingemail+\(uuid)@testing.com")
        testUser.password = "password"
        testUser.signUp()
        
        var testingBook = Book()
        testingBook.isbn13 = "1122334455667"
        testingBook.title = "testingTitle"
        testingBook.language = "Klingon"
        testingBook.authorName = "Steve Jobs"
        testingBook.publisherName = "Apple"
        testingBook.editionInfo = "4th Edition"
        testingBook.save()
        
        var soldListing1 = Listing()
        soldListing1.book = testingBook
        soldListing1.price = 35
        soldListing1.seller = testUser
        soldListing1.isActive = false
        soldListing1.isOnHold = false
        soldListing1.save()
        
        var soldListing2 = Listing()
        soldListing2.book = testingBook
        soldListing2.price = 40
        soldListing2.seller = testUser
        soldListing2.isActive = false
        soldListing2.isOnHold = false
        soldListing2.save()
        
        var soldListing3 = Listing()
        soldListing3.book = testingBook
        soldListing3.price = 82
        soldListing3.seller = testUser
        soldListing3.isActive = false
        soldListing3.isOnHold = false
        soldListing3.save()
        
        var activeListing = Listing()
        activeListing.book = testingBook
        activeListing.price = 35
        activeListing.seller = testUser
        activeListing.isActive = true
        activeListing.isOnHold = false
        activeListing.save()
        
        var results : [Listing] = UserController.getCurrentUsersSoldListings()!
        var resultObjectIds : [String] = []
        for listing in results{
            resultObjectIds.append(listing.objectId)
        }
        
        XCTAssert(contains(resultObjectIds, soldListing1.objectId), "First sold listing was not present in results.")
        XCTAssert(contains(resultObjectIds, soldListing2.objectId), "Second sold listing was not present in results.")
        XCTAssert(contains(resultObjectIds, soldListing3.objectId), "Third sold listing was not present in results.")
        XCTAssert(!contains(resultObjectIds, activeListing.objectId), "Active listing was present in results.")
        
        //Clean up the objects we created to avoid overfilling the database.
        activeListing.delete()
        soldListing3.delete()
        soldListing2.delete()
        soldListing1.delete()
        testingBook.delete()
        
    }
    
    func testGetUsersBoughtListings(){
        
    }
    
    
    func testGetUsersActiveListings(){
        
    }
    

}
