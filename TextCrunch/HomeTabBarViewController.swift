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
	
	// When the logout button is clicked logs the current user out of their account
	// and returns the user to the login screen.
	/*
	var test = 1
	test = 2
	
	
	
	*/

	@IBAction func onLogoutButtonClicked(sender: AnyObject) {
	
		// Log the current user out
		if UserController.logoutCurrentUser() {
			// If the user has been logged out, segue to the login screen
			self.performSegueWithIdentifier("LogoutSegue", sender: nil)
		}
	}
	
	// Called before seguing to another view
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "LogoutSegue") {
			//var mailboxViewController = MailboxViewController as MailboxViewController
		}
	}
}