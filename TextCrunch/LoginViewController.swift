//
//  LoginViewController.swift
//  TextCrunch
//
//  Created by Derek Dowling on 2015-01-12.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	// Text fields for user login information
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	// Labels for login warnings
	@IBOutlet weak var emailWarningLabel: UILabel!
	@IBOutlet weak var passwordWarningLabel: UILabel!
	
	// User Controller
	//var controller = UserController()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		showLoginWarning(false, showPasswordWarning: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
	
	// Handles the Login button press event.
	@IBAction func loginButtonPressed(sender: AnyObject) {
		if loginUser() {
			self.performSegueWithIdentifier("Login",sender: nil)
		}
	}
	
	// Handles the Create Account button press event.
	@IBAction func createAccountButtonPressed(sender: AnyObject) {
		self.performSegueWithIdentifier("CreateAccount", sender: nil)
	}
	
	// Attempts to login the User in, with the given email and password
	// returns true if the User has been successfully logged in
	// returns false if the login was unsuccessful
	func loginUser() -> Bool {
		var loginSuccessful = false
		var isValidEmail = !emailTextField.text.isEmpty
		var isValidPass = !passwordTextField.text.isEmpty
		
		// Attempt to login user
		if isValidEmail && isValidPass {
			var retVal = UserController.loginUser(emailTextField.text, password: passwordTextField.text)
			loginSuccessful = (retVal.code == UserController.UCCode.LOGINSUCCESS)
			
			isValidEmail = loginSuccessful
			isValidPass = loginSuccessful
			
			if (retVal.code == UserController.UCCode.LOGINFAIL_PASSWORD) {
				isValidPass = false
			}
			
		}
		
		// Show/Hide login warnings
		showLoginWarning(!isValidEmail, showPasswordWarning: !isValidPass)
		
		return loginSuccessful
	}
	
	// Shows or hides the login warning indicating that the User's
	// email or password are incorrect
	func showLoginWarning(showEmailWarning: Bool, showPasswordWarning: Bool) {
		emailWarningLabel.hidden = !showEmailWarning
		passwordWarningLabel.hidden = (!showPasswordWarning || showEmailWarning)
	}
}

