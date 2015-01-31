//
//  UserModel.swft.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-01-12.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import CoreLocation

class UserModel {
    
    var uname: String
    var email: String
    var pass: String
    
    init(uname: String, email: String, pass:String) {
        self.uname = uname
        self.email = email
        self.pass = pass
    }
}
