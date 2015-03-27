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
    class func charge(negotiation: Negotiation, buyerMetaDataId: String) -> Bool {
        
        var data = [
            "buyerMetaDataId": buyerMetaDataId,
            "negotiatonId": negotiation.objectId
        ]
        
        var response = PFCloud.callFunction("charge", withParameters: data) as [String:AnyObject]
        print(response)
        return response["success"] as Bool
    }
    
    class func capturePayment(negotiation: Negotiation) -> Bool {

//        var data : NSDictionary = {
//            "negotiationId": negotiation.objectId,
//            "captureUrl": negotiation.paymentCaptureUrl,
//            "amount": negotiation.listing.price,
//            "description": negotiation.listing.book.title
//        }
//        
//        var myDict:NSDictionary = ["Data" : negotiation]
//        
////        PFCloud.callFunctionInBackground("capturePayment", withParameters: data, {
////            (result: AnyObject!, error: NSError!) -> Void in
////            if error == nil {
////                negotiation.completed = true
////                negotiation.save()
////            } else {
////                print(error)
////            }
////        })
//        
//        var result = PFCloud.callFunction("capturePayment", withParameters: data)
//        print(result)
//        return result as Bool
        return true
    }
    
    class func saveCodeAsToken(userEmail: String, code: String) -> Bool {
        
        var data = [
            "userEmail": userEmail,
            "code": code
        ]
        
        var success = PFCloud.callFunction("paypalCodeToToken", withParameters: data) as [String:AnyObject]
        print(success)
        return success["success"] as Bool
    }
}