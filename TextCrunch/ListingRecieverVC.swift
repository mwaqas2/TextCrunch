//
//  CreateListingRecieverVC.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-02.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//


import Foundation
import UIKit


class CreateListingRecieverVC: UIViewController {
    
    //These are not empty strings
    //They contain strings from CreateListingVC
    
    //@IBOutlet var TitleLabel: UILabel!
    var LabelTitleText =  String()
    
    //@IBOutlet var AuthorLabel: UILabel!
    var AuthorLabelText = String()
    
    //@IBOutlet var SubjectLabel: UILabel!
    var SubjectLabelText = String()
    
    
    //@IBOutlet var InstitutionLabel: UILabel!
    var InstitutionLabelText = String()
    
    //@IBOutlet var ProgramLabel: UILabel!
    var ProgramLabelText = String()
    
    
    //@IBOutlet var Conditionlabel: UILabel!
    var ConditionlabelText = String()
    
    
    //@IBOutlet var PriceLabel: UILabel!
    var PriceLabelText = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        TitleLabel.text = LabelTitleText
        
        AuthorLabel.text = AuthorLabelText
        SubjectLabel.text = SubjectLabelText
        InstitutionLabel.text = InstitutionLabelText
        ProgramLabel.text = ProgramLabelText
        Conditionlabel.text = ConditionlabelText
        PriceLabel.text = PriceLabelText*/
        
        //background color scheme
        //it is very hard to do radial gradience, might as well upload an mpg background
        //this should be refactored later
        let topColor = UIColor(red: (0/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)
        let bottomColor = UIColor(red: (20/255.0), green: (150/255.0), blue: (130/255.0), alpha: 1)
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame=self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}