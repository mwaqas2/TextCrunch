//
//  UserModel.swft.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-01-12.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import CoreLocation

public class UserModel {
    var email: String
    var pass: String
    var accountId: String
    var paymentToken: String
    var currentLocation: CLLocation?
    
    public init(email: String, pass: String){
        self.email = email
        self.pass = pass
        self.accountId = ""
        self.paymentToken = ""
    }
    
}
