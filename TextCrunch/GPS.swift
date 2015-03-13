//
//  GPS.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-03-12.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//


import Foundation
import CoreLocation

class GPS: NSObject, CLLocationManagerDelegate {
    
    var currentLocation = CLLocation()
    var locationManager: CLLocationManager!
    var occurError : Bool = false
    var latitude:Double!
    var longitude:Double!
    
    
    func startTracking() {
        // just call this to update user location once
        // for continous location update remove the line
        // inside location manager function
        // self.locationManager.stopUpdatingLocation()

        print("here")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (occurError == false) {
                occurError = true
                print(error)
            }
        }
        //Edmonton coordinates, if gps fails default to that location
        var point:PFGeoPoint = PFGeoPoint(location: CLLocation(latitude: 53.544389, longitude: -113.4909267)!)
    }
    
    //Sometimes this doesnt get called
      func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        print("here2")
        var latValue = self.locationManager.location.coordinate.latitude
        var lonValue = self.locationManager.location.coordinate.longitude
        
        //just update it here
        self.latitude = (latValue) as Double
        self.longitude = (lonValue) as Double
        print("user")
        var point:PFGeoPoint = PFGeoPoint(location: CLLocation(latitude: self.latitude, longitude: self.longitude)!)
        var userlocation =  UserController.getCurrentUser()
        print(userlocation)
        userlocation["location"] = point
        userlocation.save()
        print("here3")
        self.locationManager.stopUpdatingLocation()

    }
    
}