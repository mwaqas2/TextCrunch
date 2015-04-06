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
	
	let permissions = ["public_profile"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pentagon.png")!)

		showLoginWarning(false, showPasswordWarning: false)
		
		// Hide the back navigation button in this view
		self.navigationItem.setHidesBackButton(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
        super.prepareForSegue(segue, sender: sender)
	}
	
	// Handles the Login button press event.
	@IBAction func loginButtonPressed(sender: AnyObject) {
		if loginUser() {
			self.performSegueWithIdentifier("SearchLogin",sender: nil)
		}
	}

    @IBAction func facebookLogin(sender: AnyObject) {
        
        //Remember users are not synced!
        PFFacebookUtils.logInWithPermissions(self.permissions, { (user: PFUser!, error: NSError!) -> Void in if user == nil { NSLog("Click the button to log in") }
            
        else if user.isNew {
            FBRequest.requestForMe()?.startWithCompletionHandler({(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) in
                
                if(error != nil){
                    println("Error Getting ME: \(error)");
                }
                else{
                    
                    if result.email != nil {
                        user.email = result.email
                        user.username = result.email
                        user.save()
                        if PFUser.currentUser().email != nil{
                            self.performSegueWithIdentifier("SearchLogin",sender: nil)}
                    } //if email!=nil
                }
            })
            
        } else {
            FBRequest.requestForMe()?.startWithCompletionHandler({(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) in
                if(error != nil){
                    println("Error Getting ME: \(error)");
                }
                else{
                    if result.email != nil {
                        user.email = result.email
                        user.username = result.email
                        user.save()
                        if PFUser.currentUser().email != nil {
                            self.performSegueWithIdentifier("SearchLogin",sender: nil)
                        }//if email!=nil
                    }
                }
            }); //FBrequest
            }
        }) //PFfacebookutils
    }

    
	// Handles the Create Account button press event.
	@IBAction func createAccountButtonPressed(sender: AnyObject) {
		self.performSegueWithIdentifier("CreateAccount", sender: nil)
	}
	
	// Attempts to log the User in, with the given email and password
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

