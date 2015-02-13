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
	@IBOutlet weak var confirmPasswordTextField: UITextField!
	
	// Labels for account creation warnings
	@IBOutlet weak var passwordMatchWarningLabel: UILabel!
	@IBOutlet weak var invalidPassWarningLabel: UILabel!
	@IBOutlet weak var uniqueEmailWarningLabel: UILabel!
	@IBOutlet weak var invalidEmailWarningLabel: UILabel!
	
	let minPasswordLength = 8
	
	// Handles the Create Account button press event.
	@IBAction func createAccountButtonPressed(sender: AnyObject) {
		if createAccount() {
			self.performSegueWithIdentifier("AccountCreationSuccessful", sender: nil)			
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Init all warning labels as hidden
		showAccountInfoWarning(UserController.UCCode.CREATESUCCESS, isEmailValid: true, isPassValid: true, isConfirmPassValid: true)
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
		
		// TODO: Check if the entered email is a valid email
		return true
	}
	
	// Checks if the User has entered a password. Returns true if password is correct.
	func isValidPassword() -> Bool {
		if (passwordTextField.text.utf16Count < minPasswordLength) {
			return false
		}
		
		// TODO: Check if the given password contains valid characters
		return true
	}
	
	// Checks if the User has entered the confirmation password. Returns true if the confirmation password
	// is correct
	func isValidConfirmPass() -> Bool {
		if (confirmPasswordTextField.text.utf16Count < minPasswordLength) {
			
		}
		
		// Check that the password and confirmed password match
		return (passwordTextField.text == confirmPasswordTextField.text)
	}
	
	// Creates a new User in the parse database
	func createAccount() -> Bool {
		var accountCreated = false
		var isAllowedEmail = isValidEmail()
		var isAllowedPass = isValidPassword()
		var isAllowedConfirmPass = isValidConfirmPass()
		
		var retVal = UserController.UCCode.INVALID
		
		// Attempt to create a new account in the Parse DB
		if isAllowedEmail && isAllowedPass && isAllowedConfirmPass {
			retVal = UserController.createUserAccount(emailTextField.text, password: passwordTextField.text).code
			
			accountCreated = (retVal == UserController.UCCode.CREATESUCCESS)
		}
		
		// Show or hide warning labels
		showAccountInfoWarning(retVal, isEmailValid: isAllowedEmail, isPassValid: isAllowedPass, isConfirmPassValid: isAllowedConfirmPass)
		
		return accountCreated
	}
	
	// Shows or hides the warnings related to the input User Email
	func showAccountInfoWarning(errorCode: UserController.UCCode, isEmailValid: Bool, isPassValid: Bool, isConfirmPassValid: Bool) {
		// Hide all warning labels by default
		invalidPassWarningLabel.hidden = true
		passwordMatchWarningLabel.hidden = true
		uniqueEmailWarningLabel.hidden = true
		invalidEmailWarningLabel.hidden = true
		
		if !isEmailValid {
			invalidEmailWarningLabel.hidden = false
		}
		else if !isPassValid {
			invalidPassWarningLabel.hidden = false
		}
		else if !isConfirmPassValid {
			passwordMatchWarningLabel.hidden = false
		}
		else if (errorCode == UserController.UCCode.CREATEFAIL_EMAILEXISTS) {
			uniqueEmailWarningLabel.hidden = false
		}
		else if (errorCode != UserController.UCCode.CREATESUCCESS)
		{
			invalidEmailWarningLabel.hidden = false
		}
	}
}
