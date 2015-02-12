//
//  ListingViewController.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-10.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import UIKit

class ListingViewController: UIViewController {
    

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var edition: UILabel!
    @IBOutlet weak var isbn13: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var language: UILabel!
    
    @IBOutlet weak var editListing: UIButton!
    @IBOutlet weak var buy: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = BackgroundSetting()
        let background = gradientLayer.background()
        background.frame=self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        price.text = "$100"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}