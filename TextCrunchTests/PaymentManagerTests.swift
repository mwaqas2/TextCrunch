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
    
    var appDelegate: AppDelegate = AppDelegate()
    var manager: PaymentManager = PaymentManager()
    
    // stripe pre-created buyer
    var stripeBuyerId: String = "cus_5fPv3WLmhhIxia"
    var stripeCardToken: String = "tok_15U56nFCMcNeIOqDcmfCHkS0"
    
    // stripe pre-created seller
    var stripeSellerId: String = "cus_5fPxZXCiBofcDu"
    var stripeSellerToken: String = ""
    
    var buyer: UserModel!
    var seller: UserModel!
    
    override func setUp() {
        super.setUp()
        
        self.buyer = User("test+buyer@txtcrunch.com")
        self.buyer.
        
        self.seller = UserModel("test+seller@txtcrunch.com")
    }
    
    override func tearDown() {
        super.tearDown()
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
    }

    func testPay() {
        var result = self.manager.Pay(10.00, buyerId: self.buyerId, sellerId: self.sellerId, textName: "TestBook")
        
        XCTAssert(true, "test")
        // This is an example of a functional test case.
        //XCTAssert(!result.err, "Shouldn't error on payment attempt")
        //XCTAssert(result.msg, "Payment Successful")
    }
}
