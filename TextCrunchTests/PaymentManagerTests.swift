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
//    // This one requires manually going through the paypal buyer flow in order to get a code to use below
//    func testSaveCodeAsToken() {
//        var code = "EOVdvvoByqb-N1OoR0ofNvJtTogVEOWwDuNSaBAO2qbw0ZwTVA0CMt2Vuk9axigpySoxY1YWtYfcLZ_V7edXwr7IV916S81lle2cYZt6V1zO8lW1OX80kyp0-gF3G_pVze0oZMQ7MXc7cOwpwNWVKJqTFvOv2HnSLilfuScUh3LP"
//        var result = PaymentManager.saveCodeAsToken(buyer.email, code: code, type: "buyer")
//        XCTAssert(result == true, "Code conversion failed")
//    }
    
    func testCharge() {
        
        // TODO hook these all up to pull name and seller parse id from the view
        var amount: Float = 20.00
        var paypalMetaDataID = PayPalMobile.clientMetadataID()
        var sellerEmail = buyer.email
        var bookTitle = "Tom Sawyer"
        var paypalMetaDataId = PayPalMobile.clientMetadataID()
        
        var result = PaymentManager.charge(amount, buyerMetaDataId: paypalMetaDataID, sellerEmail: sellerEmail, textName: bookTitle)
        
        // This is an example of a functional test case.
        XCTAssert(result == true, "Shouldn't error on payment attempt")
    }
}
