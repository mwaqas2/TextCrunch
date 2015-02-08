//
//  BuyVC.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-08.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


import UIKit


class Buy_VC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let gradientLayer = BackgroundSetting()
        let background = gradientLayer.background()
        
        background.frame=self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}