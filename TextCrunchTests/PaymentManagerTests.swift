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
    
    var sellerEmail = "me@derekdowling.com"
    var sellerPW = "test4567"
    
    var buyer: PFUser!
    var seller: PFUser!
    
    var listing: Listing!
    var negotiation: Negotiation!
    
    override func setUp() {
        super.setUp()
        
        appDelegate = AppDelegate()
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
        manager = PaymentManager()
        
        var query = User.query()
        query.whereKey("email", equalTo:buyerEmail)
        buyer = query.findObjects().first as User
        
        print(buyer)
        
        var query2 = User.query()
        query2.whereKey("email", equalTo:sellerEmail)
        seller = query2.findObjects().first as User
        
        var bookQ = PFQuery(className:"Book")
        var book = bookQ.getObjectWithId("gR493QRK6g") as Book
        
        listing = Listing()
        listing.buyer = buyer
        listing.seller = seller
        listing.book = book
        listing.price = 20.00
        listing.save()
        
        negotiation = Negotiation()
        negotiation.seller = seller as User
        negotiation.buyer = buyer as User
        negotiation.listing = listing
        negotiation.save()
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
    
    func testPaymentFlow() {
        
        // TODO hook these all up to pull name and seller parse id from the view
        var paypalMetaDataID = PayPalMobile.clientMetadataID()
        
        var chargeResult = PaymentManager.prepareCharge(negotiation, buyerMetaDataId: paypalMetaDataID)
        
        // This is an example of a functional test case.
        XCTAssert(chargeResult == true, "Shouldn't error on payment attempt")
 
        negotiation.fetch()
        
        var payResult = PaymentManager.capturePayment(negotiation)
        XCTAssert(payResult == true, "Error capturing payment")
    }
}
