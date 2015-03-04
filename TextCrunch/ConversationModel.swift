//
//  ConversationModel.swift
//  TextCrunch
//
//  Created by Erin Torbiak on 2015-02-06.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class Conversation : PFObject, PFSubclassing {
	@NSManaged var buyer: User
	@NSManaged var seller: User
	@NSManaged var messages: [Message]
	@NSManaged var listingId: String
	@NSManaged var isActive: Boolean
	
	override class func load() {
		self.registerSubclass()
	}
	
	class func parseClassName() -> String! {
		return "Conversation"
	}
}
