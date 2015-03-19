 //
//  BillingInfoViewController.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-10.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import UIKit

class BillingInfoViewController: UIViewController, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate {
    
    var seller: Bool = false
    var config = PayPalConfiguration()
    var resultText = ""
    @IBOutlet weak var successView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets some handy sandbox defaults
        config.forceDefaultsInSandbox = true
        config.sandboxUserPassword = "test1234"
        
        // TODO in production use currentUser for default email
        config.defaultUserEmail = "me-buyer@derekdowling.com"
        config.rememberUser = true
        config.merchantName = "TxtCrunch"
        config.merchantPrivacyPolicyURL = NSURL(string: "http://txtcrunch.com/privacy")
        config.merchantUserAgreementURL = NSURL(string: "http://txtcrunch.com/user-agreement")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: get smarter about configuring this on the fly
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
    }
    
    // Called when the Corresponding Create Info Button is Clicked
    @IBAction func authorizePaymentInfo(sender: AnyObject) {
        
        var currentUser = User.currentUser()
        
        // Gross If/Else Statement
        
        if (self.seller) {
            let scopes = [kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]
            let profileSharingViewController = PayPalProfileSharingViewController(scopeValues: NSSet(array: scopes), configuration: self.config, delegate: self)
            presentViewController(profileSharingViewController, animated: true, completion: nil)
            
        } else {
        
            // if no previous payment data exists, create new info
            if(currentUser.paypalToken == nil) {
                let newPaymentInfoController = PayPalFuturePaymentViewController(configuration: config, delegate: self)
                presentViewController(newPaymentInfoController, animated: true, completion: nil)
            } else {
                let newPaymentInfoController = PayPalFuturePaymentViewController(configuration: config, delegate: self)
                presentViewController(newPaymentInfoController, animated: true, completion: nil)
            }
        }
    }
    
    func payPalFuturePaymentDidCancel(futurePaymentViewController: PayPalFuturePaymentViewController!) {
        println("PayPal Future Payment Authorizaiton Canceled")
        successView.hidden = true
        futurePaymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Called when a buyer completes the Future Payment Flow
    func payPalFuturePaymentViewController(
        futurePaymentViewController: PayPalFuturePaymentViewController!,
        didAuthorizeFuturePayment response: [NSObject : AnyObject]!
    ) {
        
        // send authorizaiton to your server to get refresh token.
        futurePaymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            if (self.convertPaymentCodeToToken(response, mode:"buyer")) {
                self.performSegueWithIdentifier("EditSearchListing", sender: nil)
            } else {
                // TODO: error
            }
            
        })
    }
    
    func userDidCancelPayPalProfileSharingViewController(profileSharingViewController: PayPalProfileSharingViewController!) {
        println("PayPal Profile Sharing Authorization Canceled")
        successView.hidden = true
        profileSharingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Called when seller completes Profile Sharing View Controller
    func payPalProfileSharingViewController(
        profileSharingViewController: PayPalProfileSharingViewController!,
        userDidLogInWithAuthorization response: [NSObject : AnyObject]!
    ) {
        
        // send authorization to your server
        profileSharingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            if (self.convertPaymentCodeToToken(response, mode: "seller")) {
                self.performSegueWithIdentifier("ViewSearchListing", sender: nil)
            } else {
                // TODO: error
            }
            
        })
    }
    
    // Handles making the appropriate calls to extract and save a the user's paypal info
    // for sellers
    func convertPaymentCodeToToken(response: [NSObject : AnyObject]!, mode: String) -> Bool {
  
        var response = response["response"] as? [String: String]
        
        if response!["code"] != nil {
        
            var userEmail = User.currentUser().email
            var code = response?["code"]
            
            if code? != nil {
            
                if mode == "buyer" {
                    return PaymentManager.saveBuyerCodeAsToken(userEmail, code: code!)
                } else {
                    return PaymentManager.saveSellerCodeAsToken(userEmail, code: code!)
                }
            }
        }
        
        // if we get to here something went wrong
        return false
    }
    
    @IBAction func confirmPaymentButtonPressed(sender: AnyObject) {
        
        // TODO hook these all up to pull name and seller parse id from the view
        var amount: Float = 20.00
        var paypalMetaDataID = PayPalMobile.clientMetadataID()
        var sellerEmail = User.currentUser().email
        var bookTitle = "Tom Sawyer"
        
        var result = PaymentManager.charge(amount, buyerMetaDataId: paypalMetaDataID, sellerEmail: sellerEmail, textName: bookTitle)
        print(result)
    }
    
    func showSuccess() {
        successView.hidden = false
        successView.alpha = 1.0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelay(2.0)
        successView.alpha = 0.0
        UIView.commitAnimations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}