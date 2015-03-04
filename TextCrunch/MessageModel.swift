//
//  MessageModel.swift
//  TextCrunch
//
//  Created by Erin Torbiak on 2015-02-06.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class Message : PFObject, PFSubclassing {
	@NSManaged var sender: User
	@NSManaged var receiver: User
	@NSManaged var content: String
	
	override class func load() {
		self.registerSubclass()
	}
	
	class func parseClassName() -> String! {
		return "Message"
	}
}
