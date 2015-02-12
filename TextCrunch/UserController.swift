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
    
    enum UCCode : Int {
        case LOGINFAIL_PASSWORD = 0
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
    func loginUser(loginUser: User, password: String) -> (code: UCCode, error: String!) {
        
        var resultCode = UCCode.LOGINFAIL_MISC
        var error : NSError?
        var errorMsg: String! = ""
        
        var user = User.logInWithUsername(loginUser.email, password: password, error: &error)
        if (user == nil) {//Either the account doesn't exist or the password is wrong.
            
            //Marshall error into return value for showing in the app
            errorMsg = error?.userInfo?["error"] as String!
            
            if (error?.userInfo?["code"] as Int == kPFErrorObjectNotFound) {
                resultCode = .LOGINFAIL_NEXIST
            } else {
                resultCode = .LOGINFAIL_PASSWORD
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
    func createUserAccount(user: User, password: String) -> (code: UCCode, error: String!) {
        
        user.password = password
        
        var resultCode = UCCode.CREATEFAIL_MISC
        var error: NSError?
        var errorMsg: String! = ""

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
    func deleteCurrentUserAccount() -> Bool {
        var currentUser = PFUser.currentUser()
        var result = currentUser.delete()
        return result
    }
    
    //Logs out the current user.
    //Returns true if the logout was sucessful and false if there is still a user logged in.
    func logoutCurrentUser() -> Bool {
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        return (currentUser == nil)
    }
    
    //Initiates password reset with Parse by sending the user a password reset email.
    func resetCurrentUserPassword() -> Void{
        var currentUser = PFUser.currentUser()
        PFUser.requestPasswordResetForEmailInBackground(currentUser.email, block: nil)
        return
    }
    
    //Incomplete until the Listing model stuff is complete and moved in.
    func getUsersSoldListings(user: User) -> [Listing]?{
        return nil
    }
    
    func getUsersBoughtListings(user: User) -> [Listing]?{
        return nil
    }
    
    func getUsersActiveListings(user: User) -> [Listing]?{
        return nil
    }
    
}






