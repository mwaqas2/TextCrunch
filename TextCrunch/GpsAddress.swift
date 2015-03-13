//
//  GpsAddress.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-03-12.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import CoreLocation

class GpsAddress: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    
    
    var JsonGpsInfo: JSON!
    let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="
    let urladd = "https://maps.googleapis.com/maps/api/geocode/json?address="
    
    
    //stalker mode w/ distance of kCLLocationAccuracyBest(~6meters)    
    func getAddress(lat: String, lng:String) -> String{
        
        var coor = lat+","+lng
        var urlandcoor = url+coor
        var JsonGpsInfo = JSON(url:urlandcoor)
        var locationexist = toString(JsonGpsInfo["status"])
        var hasaddress = (locationexist=="OK")
        print("hasaddress \(hasaddress)")
        if (hasaddress){
            var Address = JsonGpsInfo["results"][0]["formatted_address"]
            print("Address \(Address)")
            return Address.toString()
        }
        return "Edmonton, Alberta"
        
    }
    
    func getCoordinates(Address: String) -> String{
        //next line is url encoding
        var escapedlocation = Address.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        var coor = urladd+escapedlocation!
        var urlandcoor = url+coor
        var JsonGpsInfo = JSON(url:urlandcoor)
        var locationexist = toString(JsonGpsInfo["status"])
        var hascoor = (locationexist=="OK")
        print("hascoord \(hascoor)")
        if (hascoor){
            var lat = JsonGpsInfo["results"][0]["geometry"]["location"]["lat"].toString()
            var lng = JsonGpsInfo["results"][0]["geometry"]["location"]["lng"].toString()
            return lat+lng
        }
        //Edmonton coordinates
        return "53.544389,-113.4909267 "
        
    }
    
    
    
    
}