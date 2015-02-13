//
//  UserModel.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-02-12.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class User : PFUser, PFSubclassing {
    
    @NSManaged var stripeCardToken: String
    @NSManaged var stripeId: String
    @NSManaged var stripeSellerToken: String
    
    override init() {
        super.init()
    }
    
    convenience init(email: String) {
        self.init()
        self.email = email
        self.username = email
    }
}