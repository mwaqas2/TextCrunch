//
//  HomeTabBarViewController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-15.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pentagon.png")!)
		// Hide the back navigation button in this view
		self.navigationItem.setHidesBackButton(true, animated: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	/*
	// MARK: - Navigation
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}