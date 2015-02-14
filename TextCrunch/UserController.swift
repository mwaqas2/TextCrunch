//
//  UserController.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-01-31.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


//The base UserController class for non-social network user management.
public class UserController {
    
    enum UCCode : Int{
		case INVALID = -1
        case LOGINFAIL_PASSWORD
        case LOGINFAIL_NEXIST
        case LOGINFAIL_EMAIL
        case LOGINFAIL_MISC
        case LOGINSUCCESS
        
        case CREATEFAIL_MISC
        case CREATEFAIL_EMAILEXISTS
        case CREATESUCCESS
    }
    
    
    //Logs in using the passed in User, setting it as the app's current user.
    //Returns a UCCode indicating the success or failure of logging in the user.
    //Returns .LOGINSUCCESS, .LOGINFAIL_NEXIST, .LOGINFAIL_PASSWORD, or .LOGINFAIL_MISC
    class func loginUser(email: String, password: String) -> (code: UCCode, error: String!) {
        var resultCode = UCCode.LOGINFAIL_MISC
        var error : NSError?
        var errorMsg: String = ""
        
        var user = User.logInWithUsername(email, password: password, error: &error)
        if (user == nil) {//Either the account doesn't exist or the password is wrong.
            
            //Marshall error into return value for showing in the app
            errorMsg = error?.userInfo?["error"] as String!
            
            if (error?.userInfo?["code"] as Int == kPFErrorObjectNotFound) {
                resultCode = .LOGINFAIL_NEXIST
            }
        } else {
            resultCode = .LOGINSUCCESS
        }
        
        return (resultCode, errorMsg)
    }
    
    
    //Adds the passed user model to Parse as a new user.
    //Returns a UCCode indicating the success or failure of adding the user.
    //Returns .CREATESUCCESS, .CREATEFAIL_EMAILEXISTS, or .CREATEFAIL_MISC.
    //Currently adds the user synchronously.
    class func createUserAccount(email: String, password: String) -> (code: UCCode, error: String!) {
        
        var user = User()
        user.email = email
        user.password = password
        user.username = email
        
        var resultCode = UCCode.CREATEFAIL_MISC
        var error: NSError?
        var errorMsg: String = ""

        var result = user.signUp(&error)
        if(!result) {
            resultCode = UCCode.CREATEFAIL_EMAILEXISTS
            errorMsg = error?.userInfo?["error"] as String!
        } else {
            resultCode = UCCode.CREATESUCCESS
        }
        return (resultCode, errorMsg)
    }
    
    //Deletes the account of the user currently logged in.
    //Returns true if the deletion was successful and false if it was not.
    class func deleteCurrentUserAccount() -> Bool{
        var currentUser = PFUser.currentUser()
        var result = currentUser.delete()
        return result
    }
    
    //Logs out the current user.
    //Returns true if the logout was sucessful and false if there is still a user logged in.
    class func logoutCurrentUser() -> Bool{
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        return (currentUser == nil)
    }
    
    //Initiates password reset with Parse by sending the user a password reset email.
    class func resetCurrentUserPassword() -> Void{
        var currentUser = PFUser.currentUser()
        PFUser.requestPasswordResetForEmailInBackground(currentUser.email, block: nil)
        return
    }
    
    class func getCurrentUser() -> User{
        var currentUser: User = User.currentUser()
        return currentUser
    }
    
    class func getCurrentUsersSoldListings() -> [Listing]?{
        var currentUser = self.getCurrentUser()
        var query = PFQuery(className: "Listing")
        query.whereKey("isActive", equalTo: false)
        query.whereKey("seller", equalTo: currentUser)
        var results = query.findObjects()
        return results as? [Listing]
    }
    
    class func getCurrentUsersBoughtListings() -> [Listing]?{
        var currentUser = self.getCurrentUser()
        var query = PFQuery(className: "Listing")
        query.whereKey("isActive", equalTo: false)
        query.whereKey("buyer", equalTo: currentUser)
        var results = query.findObjects()
        return results as? [Listing]
    }
    
    class func getCurrentUsersActiveListings() -> [Listing]?{
        var currentUser = self.getCurrentUser()
        var buyerQuery = PFQuery(className: "Listing")
        var sellerQuery = PFQuery(className: "Listing")
        buyerQuery.whereKey("isActive", equalTo: true)
        buyerQuery.whereKey("buyer", equalTo: currentUser)
        //Kind of redundant, since we should never have the case where a listing has a buyer and is active.
        //Unless we want to set up where we set the buyer on putting a listing on hold.
        sellerQuery.whereKey("isActive", equalTo: true)
        sellerQuery.whereKey("seller", equalTo: currentUser)
        var compoundQuery = PFQuery.orQueryWithSubqueries([buyerQuery, sellerQuery])
        var results = compoundQuery.findObjects()
        return results as? [Listing]
    }
    
    class func getCurrentUsersCompleteListings() -> [Listing]?{
        return nil
    }
    

    class func getAllCurrentUsersListings() -> [Listing]?{
        return nil
    }
    
}






