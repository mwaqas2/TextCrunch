//
//  BuyerInfoController.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-02-06.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class BuyerInfoController: UIViewController, PTKViewDelegate {
    
    var paymentView: PTKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var view = PTKView(frame: CGRectMake(15, 20, 290, 55))
        self.paymentView = view;
        self.paymentView?.delegate = self;
    }
    
    // Called when the payment information has been successfully validated
    func paymentView(paymentView: PTKView!, withCard card: PTKCard!, isValid valid: Bool) {
        // TODO: Enable a save button
    }
}