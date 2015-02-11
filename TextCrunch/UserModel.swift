//
//  User.swft.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-01-12.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import CoreLocation

class PSUser : PFUser, PFSubclassing {

    required init(email: String!, stripeId: String = "") {
        super.init()
        
        self.email = email
        self.username = email
        self.setStripeId(stripeId)
        
    }
    
    func setStripeId(id: String) {
        self["stripeId"] = id
    }
    
    func getStripeId() -> String {
        return self["stripeId"] as String
    }
    
    
//    // Persists the user
//    func save() -> Bool {
//        var parse = self.toParse()
//        return parse.save()
//    }
//    
//    // Optional Signup Call, Mostly For Testing
//    func signUp(password: String) -> Bool {
//        var model = self.toParse()
//        model.password = password
//        return model.signUp()
//    }
//    
//    // manually marshals the user model into stripe
//    func toParse() -> PFUser {
//        var user = PFUser()
//        user.email = self.email
//        user.username = self.email
//        user["stripeId"] = self.stripeId
//        
//        return user
//    }
//    
//    class func marshal(parse: PFUser) -> User {
//        
//        // use this classes constructor
//        return self(
//            email: parse.email,
//            stripeId: parse["stripeId"] as String,
//            parseId: parse.objectId
//        )
//        
//    }
    
    override class func load() {
        superclass()?.load()
        self.registerSubclass()
    }
    
    override class func parseClassName() -> String! {
        return "PSUser"
    }
    
}
