//
//  ConversationDatabaseController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-03-19.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//
//	Controller that modifies and retrieves information from
//	the Parse database containing bconversations between users.

import Foundation

class ConversationDatabaseController {
	// Type method that searches the parse db for listings that match
	// the provided query. Accepts a callback function that is called when
	// the query is complete
	class func getUserConversations(isBuyer: Bool, callback: ([Conversation]) -> Void) {
		// Search for Conversations where the user ID matches that of the current user
		var conversationQuery = PFQuery(className: "Conversation")
		
		// Find conversations where the current user matches the buyer or the seller
		if isBuyer {
			conversationQuery.whereKey("buyer", equalTo:UserController.getCurrentUser())
		}
		else {
			conversationQuery.whereKey("seller", equalTo:UserController.getCurrentUser())
		}

		conversationQuery.includeKey("messages")
		conversationQuery.includeKey("sender")
		conversationQuery.includeKey("listing")
		conversationQuery.includeKey("listing.book")
		conversationQuery.includeKey("listing.seller")
		conversationQuery.includeKey("listing.buyer")
		//conversationQuery.orderByAscending("Dat time ting")
		
		conversationQuery.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]!, error: NSError!) -> Void in
			if error == nil {
				// The query succeeded. Pass the matching Listings to the callback function.
				if let conversations = objects as? [Conversation] {
					callback(conversations)
				}
			}
		}
	}
	
	// Type method that searches the parse db for listings that match
	// the provided query. Accepts a callback function that is called when
	// the query is complete
	class func getListingConversation(listing: Listing, buyer: User?) -> Conversation? {
		if (buyer == nil) {
			return nil
		}
		
		// Search for Conversations where the user ID matches that of the current user
		var conversationQuery = PFQuery(className: "Conversation")
		conversationQuery.whereKey("listing", equalTo:listing)
		conversationQuery.whereKey("buyer", equalTo:buyer)
		conversationQuery.includeKey("messages")
		conversationQuery.includeKey("buyer")
		conversationQuery.includeKey("sender")
		conversationQuery.includeKey("listing.seller")
		conversationQuery.includeKey("listing.buyer")
		conversationQuery.includeKey("listing.book")
		
		// TODO: order conversations buy most recent message.
		//conversationQuery.orderByAscending("")
		
		var conversation = Conversation()
		var results = conversationQuery.findObjects()
		if (results.count > 1) {
			println("Something is wrong. Multiple conversations found for buyer on listing: " + listing.objectId)
		} else if (results.count == 1) {
			conversation = results[0] as Conversation
		} else {
			// Create new Conversation object
			conversation.seller = listing.seller as User
			conversation.buyer = UserController.getCurrentUser()
			conversation.listing = listing
			conversation.messages = []
		}
		
		return conversation
	}
}