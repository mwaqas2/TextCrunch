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
    
    // stripe pre-created buyer
    var stripeBuyerId: String = "cus_5fPv3WLmhhIxia"
    var stripeCardToken: String = "tok_15U56nFCMcNeIOqDcmfCHkS0"
    
    // stripe pre-created seller
    var stripeSellerId: String = "cus_5fPxZXCiBofcDu"
    var stripeSellerToken: String = ""
    
    var buyer: User!
    var seller: User!
    
    override func setUp() {
        super.setUp()
        
        appDelegate = AppDelegate()
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
        manager = PaymentManager()
        var uniq = NSUUID().UUIDString
        
        buyer = User(email: "test+buyer" + uniq + "@txtcrunch.com")
        buyer.stripeCardToken = stripeCardToken
        buyer.stripeId = stripeBuyerId
        buyer.password = "password1"
        buyer.signUp()
        
        seller = User(email: "test+seller" + uniq + "@txtcrunch.com")
        seller.password = "password1"
        seller.stripeId = stripeSellerId
        seller.stripeSellerToken = stripeSellerToken
        seller.signUp()
    }
    
    override func tearDown() {
        super.tearDown()
        buyer.delete()
        seller.delete()
    }

    func testPay() {
        var result = PaymentManager.pay(10.00, buyerId: buyer.objectId, sellerId: seller.objectId, textName: "TestBook")
        println(result)

        // This is an example of a functional test case.
        XCTAssert(result["err"] == nil, "Shouldn't error on payment attempt")
        XCTAssert(result["msg"] != nil, "Payment Successful")
    }
}
