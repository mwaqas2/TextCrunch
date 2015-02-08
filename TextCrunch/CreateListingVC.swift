//
//  CreateListingVC.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-08.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


import UIKit
import CoreData

class CreateListingVC: UIViewController {
    
    
    //var CreateListing = [NSManagedObject]()
    
    //@IBOutlet var TitleTextField: UITextField!
    
    /*
    @IBOutlet var TitleTextField: UITextField!
    @IBOutlet var AuthorTextField: UITextField!
    @IBOutlet var SubjectTextField: UITextField!
    @IBOutlet var InstitutionTextField: UITextField!
    @IBOutlet var ProgramTextField: UITextField!
    @IBOutlet var ConditionTextField: UITextField!
    @IBOutlet var PriceTextField: UITextField!*/
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = BackgroundSetting()
        let background = gradientLayer.background()
        
        background.frame=self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var DestinationController: CreateListingRecieverVC  = segue.destinationViewController as CreateListingRecieverVC
        
    
        DestinationController.LabelTitleText = TitleTextField.text
        
        
        DestinationController.AuthorLabelText = AuthorTextField.text
        DestinationController.SubjectLabelText = SubjectTextField.text
        DestinationController.InstitutionLabelText = InstitutionTextField.text
        DestinationController.ProgramLabelText = ProgramTextField.text
        DestinationController.ConditionlabelText = ConditionTextField.text
        DestinationController.PriceLabelText = PriceTextField.text
        
        
    }*/
    
}