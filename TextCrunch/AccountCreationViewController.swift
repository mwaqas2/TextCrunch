//
//  AccountCreationViewController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-05.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class AccountCreationViewController: UIViewController {

	// Text fields for user account creation screen
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	// Handles the Create Account button press event.
	@IBAction func createAccountButtonPressed(sender: AnyObject) {
		if isValidEmail() && isValidPassword() {
			self.performSegueWithIdentifier("AccountCreationSuccessful", sender: nil)			
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	// Checks if the User has entered an email and if the email is valid.
	// Returns true if the email is valid.
	func isValidEmail() -> Bool {
		if emailTextField.text.isEmpty {
			return false
		}
		
		// TODO: Check if the entered email is a valid email, and if the 
		// and it is a new email address (not already in the parse database)
		return true
	}
	
	// Checks if the User has entered a password and if the password matches
	// the password linked to the given email. Returns true if password is correct.
	func isValidPassword() -> Bool {
		if passwordTextField.text.isEmpty {
			return false
		}
		
		// TODO: Check if the given password contains valid characters
		// and is the correct length
		return true
	}
}
