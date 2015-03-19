//
//  PaymentManager.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-02-06.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class PaymentManager {
    
    // Charges a buyer and then pays the seller in the cloud
    class func charge(dollarAmnt: Float, buyerMetaDataId: String, sellerEmail: String, textName: String) -> Bool {
        
        var data = [
            "buyerMetaDataId": buyerMetaDataId,
            "sellerEmail": sellerEmail,
            "paymentAmount": NSString(format: "%.2f", dollarAmnt),
            "description": "Purchase of " + textName
        ]
        
        var success = PFCloud.callFunction("charge", withParameters: data) { (result: AnyObject!, error: NSError!) -> Bool in
            if error == nil {
                return true
            } else {
                print(error)
                return false
            }
            
        }
        
        return success
    }
    
    // converts a paypal code into a long lived refresh token
    class func saveBuyerCodeAsToken(buyerId: String, code: String) -> Bool {
        return PaymentManager.saveCodeAsToken(
            buyerId,
            code: code,
            type: "buyer"
        )
    }
    
    // converts a paypal seller code into a refresh token
    class func saveSellerCodeAsToken(sellerId: String, code: String) -> Bool {
        return PaymentManager.saveCodeAsToken(
            sellerId,
            code: code,
            type: "seller"
        )
    }
    
    class func saveCodeAsToken(userEmail: String, code: String, type: String) -> Bool {
        
        var data = [
            "userEmail": userEmail,
            "code": code,
            "type": type
        ]
        
        var success = PFCloud.callFunction("paypalCodeToToken", withParameters: data) { (result: AnyObject!, error: NSError!) -> Bool in
            if error == nil {
                return true
            } else {
                print(error)
                return false
            }

        }
        return success
    }
}