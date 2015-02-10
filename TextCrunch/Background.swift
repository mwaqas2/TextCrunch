//
//  Background.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-10.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

//
//  Background.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-09.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


public class BackgroundSetting {
    
    func  background() -> CAGradientLayer {
        
        let topColor = UIColor(red: (0/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)
        let bottomColor = UIColor(red: (20/255.0), green: (150/255.0), blue: (130/255.0), alpha: 1)
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
    
}