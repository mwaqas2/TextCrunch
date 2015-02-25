//
//  PaymentManager.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-02-06.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class PaymentManager {

    init() {
        
    }
    
    class func pay(dollarAmnt: Float, buyerId: String, sellerId: String, textName: String) -> [String: String] {
        // convert dollars to cents for Stripe
        var amntCents = dollarAmnt * 100
        
        var data = [
            "buyerId": buyerId,
            "sellerId": sellerId,
            "amountCents": NSString(format: "%.2f", amntCents),
            "textName": textName
        ]
        
        var result: AnyObject! = PFCloud.callFunction("charge", withParameters: data)
        var dict = result as Dictionary<String, String>
        return dict
    }
    
    // converts a paypal code into a long lived refresh token
    class func convertCode(id: String, code: String) -> Bool {
        
        return true;
        
        var data = [
            "id": id,
            "code": code
        ]
        
        // TODO: parse using JSONSWifty
        var result: AnyObject! = PFCloud.callFunction("convertCode", withParameters: data)
        var dict = result as Dictionary<String, String>
        println(dict)
        
        //return dict["result"]
        return true
    }
}