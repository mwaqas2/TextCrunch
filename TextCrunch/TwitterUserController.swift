//
//  TwitterUserController.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-01-31.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


class TwitterUserController: UserController{
    
    class func loginTwitterUser(){
        PFTwitterUtils.logInWithBlock{
            (user: PFUser!, error: NSError!) -> Void in
            if let user = user {
                if user.isNew {
                    //User just created an account with twitter.
                } else {
                    //An existing user logged in with twitter.
                }
            } else {
                //The user login failed.
            }
        }
    }

}