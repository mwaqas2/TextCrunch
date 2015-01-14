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
    
    var name: String
    var location: String
    var phone: String
    
    init(name: String, phone: String) {
        self.name = name
        self.location = ""
        
        // TODO: Ensure this is provided in a usable format
        // or format it ourselves
        self.phone = phone
    }
    
    func geolocate() {
        let gps = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            gps.startUpdatingLocation()
        }
    }
}
