//
//  ListingModelTests.swift
//  TextCrunch
//
//  Created by Erin Torbiak on 2015-02-08.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit
import XCTest

import TextCrunch

class ListingModelTests : XCTestCase {

    override func setUp() {
        super.setUp()
        Parse.setApplicationId("bd9pkI4jclGiICv1xM5YQiDfsxUD4SB4c3jQvBHW", clientKey: "nyPjmHMJAacFQVQSg7CTxZj3DWp1pKW9RBVsOPGK")
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreateListing(){
        // Not sure how to test because it is a model full of objects and everything is so decoupled due to Parse.
        //var listing = Listing()
        //listing.book = Book()
        //listing.seller = PFUser()
        //listing.price = 200
        //listing.delete()
    }
}
