//
//  PaymentManagerTests.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-02-08.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit
import XCTest
import TextCrunch

class PaymentManagerTests: XCTestCase {
    
    var appDelegate: AppDelegate!
    var manager: PaymentManager!
    
    var buyerEmail = "me@derekdowling.com"
    var buyerPW = "test1234"
    
    var sellerEmail = "me-buyer2@derekdowling.com"
    var sellerPW = "test4567"
    
    var buyer: User!
    var seller: User!
    
    override func setUp() {
        super.setUp()
        
        appDelegate = AppDelegate()
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
        manager = PaymentManager()
        
        var query = User.query()
        query.whereKey("email", equalTo:buyerEmail)
        buyer = query.findObjects().first as User

        var query2 = User.query()
        query2.whereKey("email", equalTo:sellerEmail)
        seller = query2.findObjects().first as User
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testPay() {
        var result = PaymentManager.pay(10.00, buyerId: buyer.objectId, sellerId: seller.objectId, textName: "TestBook")
        println(result)

        // This is an example of a functional test case.
        XCTAssert(result["err"] == nil, "Shouldn't error on payment attempt")
        XCTAssert(result["msg"] != nil, "Payment Successful")
    }
}
