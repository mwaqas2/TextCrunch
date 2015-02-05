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
    
    let LOGINFAIL_MISC = -1 //Login error code for unknown error.
    let LOGINFAIL_PASSWORD = 0 //Login error code for if the login password is not correct.
    let LOGINFAIL_NEXIST = 1 //Login error code for if the account does not exist.
    let LOGINFAIL_EMAIL = 2 //Login error code for if the email is incorrect.
    let LOGINSUCCESS = 3 //Login code for a successful login.
    
    let CREATEFAIL_MISC = -1 //Account creation error code for unknown error.
    let CREATEFAIL_EMAILEXISTS = 10 //Account creation error code for if the email is already in use.
    let CREATESUCCESS = 11 //Account creation code for a successful creation.
    
    func loginUser(user: UserModel) -> Int{
        return self.LOGINFAIL_MISC
    }
    
    func createUserAccount(user: UserModel) -> Int{
        return self.CREATEFAIL_MISC
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






