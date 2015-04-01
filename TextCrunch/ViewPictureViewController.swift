//
//  ViewPictureViewController.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-03-31.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


class ViewPictureViewController : UIViewController {
    
    var image: UIImage!
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad(){
        super.viewDidLoad()
        if(image != nil){
            imageView.image = image
        }
    }
}