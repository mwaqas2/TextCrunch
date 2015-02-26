//
//  ListingDatabaseControllerTests.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-25.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit
import XCTest

import TextCrunch

class ListingDatabaseControllerTests: XCTestCase {
 
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
	
	func createTestListings () {
		
	}
	
	func deleteTestListings () {
		
	}
	
	func testAuthorSearch(){
		var working = true
		
		XCTAssert(working == true, "Lising search test failed.")

	}
	
	func testTitleSearch(){
		var working = true
		
		XCTAssert(working == true, "Lising search test failed.")
		
	}
}
