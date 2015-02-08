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
    
    enum UCCode : Int{
        case LOGINFAIL_PASSWORD = 0
        case LOGINFAIL_NEXIST
        case LOGINFAIL_EMAIL
        case LOGINFAIL_MISC
        case LOGINSUCCESS
        
        case CREATEFAIL_MISC
        case CREATEFAIL_EMAILEXISTS
        case CREATESUCCESS
    }
    
    
    //Logs in using the passed in UserModel, setting it as the app's current user.
    //Returns a UCCode indicating the success or failure of logging in the user.
    //Returns .LOGINSUCCESS, .LOGINFAIL_NEXIST, .LOGINFAIL_PASSWORD, or .LOGINFAIL_MISC
    func loginUser(user: UserModel) -> UCCode{
        var resultCode = UCCode.LOGINFAIL_MISC
        var errorResult : NSError?
        //PFUser.logInWithUsername(user.email, password: user.pass)
        var resultUser = PFUser.logInWithUsername(user.email, password: user.pass, error: &errorResult)
        if (resultUser == nil){//Either the account doesn't exist or the password is wrong.
            var query = PFUser.query()
            query.whereKey("username", equalTo: user.email)
            //Checks to see if an account with the given username/email exists,
            //if there is one the error must be that the password is wrong.
            var queryResults = query.findObjects()
            if (queryResults.count == 0){
                resultCode = .LOGINFAIL_NEXIST
            } else {
                resultCode = .LOGINFAIL_PASSWORD
            }
        } else {
            resultCode = .LOGINSUCCESS
        }
        return resultCode
    }
    
    
    //Adds the passed user model to Parse as a new user.
    //Returns a UCCode indicating the success or failure of adding the user.
    //Returns .CREATESUCCESS, .CREATEFAIL_EMAILEXISTS, or .CREATEFAIL_MISC.
    //Currently adds the user synchronously.
    func createUserAccount(user: UserModel) -> UCCode{
        var parseModel = PFUser()
        var resultCode = UCCode.CREATEFAIL_MISC
        parseModel.username = user.email
        parseModel.password = user.pass
        parseModel.email = user.email
        parseModel["paymentToken"] = ""//This is temporary, as the actual payment token creation requires our payment system in place.
        
        var error:NSErrorPointer = NSErrorPointer()
        var result = parseModel.signUp(error)
        if(result != true){
            println("Error creating account: \(error.debugDescription)")
            resultCode = UCCode.CREATEFAIL_EMAILEXISTS
        } else {
            resultCode = UCCode.CREATESUCCESS
        }
        return resultCode
    }
    
    
    //Returns a UserModel representing the currently logged-in user, or nil if no user is logged in.
    func getCurrentUser()-> UserModel?{
        var currentUser = PFUser.currentUser()
        if (currentUser != nil){
            var currentUserModel = UserModel(email: currentUser.username, pass: nil)
            currentUserModel.accountId = currentUser.objectId
            currentUserModel.paymentToken = currentUser["paymentToken"] as String
            return currentUserModel
        } else {
            return nil
        }
    }
    
    func deleteCurrentUserAccount() -> Bool{
        var currentUser = PFUser.currentUser()
        var result = currentUser.delete()
        return result    }
    
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






