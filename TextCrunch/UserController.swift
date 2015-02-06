//
//  UserController.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-01-31.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


//The base UserController class for non-social network user management.
class UserController{
    
   /** let LOGINFAIL_MISC = -1 //Login error code for unknown error.
    let LOGINFAIL_PASSWORD = 0 //Login error code for if the login password is not correct.
    let LOGINFAIL_NEXIST = 1 //Login error code for if the account does not exist.
    let LOGINFAIL_EMAIL = 2 //Login error code for if the email is incorrect.
    let LOGINSUCCESS = 3 //Login code for a successful login.
    
    let CREATEFAIL_MISC = -1 //Account creation error code for unknown error.
    let CREATEFAIL_EMAILEXISTS = 10 //Account creation error code for if the email is already in use.
    let CREATESUCCESS = 11 //Account creation code for a successful creation.**/
    
    enum UCCode : Int{
        case LOGINFAIL_PASSWORD = 0
        case LOGINFAIL_NEXIST
        case LOGINFAIL_EMAIL
        case LOGINFAIL_MISC
        case LOGINSUCCESS
        
        case CREATEFAIL_MISC
        case CREATEFAIL_EMAILEXISTS
        case CREATESUCESS
    }
    
    func loginUser(user: UserModel) -> UCCode{
        var resultCode = UCCode.LOGINFAIL_MISC
        return resultCode
    }
    
    
    //Adds the passed user model to Parse as a new user.
    //Returns a UCCode indicating the success or failure of adding the user.
    //Currently adds the user synchronously.
    func createUserAccount(user: UserModel) -> UCCode{
        var parseModel = PFUser()
        var resultCode = UCCode.CREATEFAIL_MISC
        parseModel.username = user.email
        parseModel.password = user.pass
        parseModel.email = user.email
        
        var error:NSErrorPointer = NSErrorPointer()
        var result = parseModel.signUp(error)
        if(result != true){
            println("Error creating account: \(error.debugDescription)")
            resultCode = UCCode.CREATEFAIL_EMAILEXISTS
        } else {
            resultCode = UCCode.CREATESUCESS
        }
        /**parseModel.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                resultCode = UCCode.CREATESUCESS
            } else {
                let errorString = error.userInfo?["error"] as NSString
                // Show the errorString somewhere and let the user try again.
                println("Error creating account: \(errorString)")
                println("Localized description: \(error.localizedDescription)")
                resultCode = UCCode.CREATEFAIL_EMAILEXISTS
            }
        }**/
        return resultCode
    }
    
    func getCurrentUser()-> UserModel?{
        return nil
    }
    
    func deleteUserAccount(user: UserModel) -> Bool{
        return false
    }
    
    func logoutUser(user: UserModel) ->Bool{
        return false
    }
    
    func resetPassword(user: UserModel) -> Bool{
        return false
    }
    
    func getUsersSoldListings(user: UserModel) -> [ListingModel]?{
        return nil
    }
    
    func getUsersBoughtListings(user: UserModel) -> [ListingModel]?{
        return nil
    }
    
    func getUsersActiveListings(user: UserModel) -> [ListingModel]?{
        return nil
    }
    
    func updateCurrentUser(){
        
    }
}






