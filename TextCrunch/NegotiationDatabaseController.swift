//
//  NegotiationDatabaseController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-03-19.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//
//	Controller that modifies and retrieves information from
//	the Parse database containing bnegotiations between users.

import Foundation

class NegotiationDatabaseController {
	// Type method that searches the parse db for listings that match
	// the provided query. Accepts a callback function that is called when
	// the query is complete
	class func getUserNegotiations(isBuyer: Bool, callback: ([Negotiation]) -> Void) {
		// Search for Negotiations where the user ID matches that of the current user
		var negotiationQuery = PFQuery(className: "Negotiation")
		
		// Find negotiations where the current user matches the buyer or the seller
		if isBuyer {
			negotiationQuery.whereKey("buyer", equalTo:UserController.getCurrentUser())
		}
		else {
			negotiationQuery.whereKey("seller", equalTo:UserController.getCurrentUser())
		}

		negotiationQuery.includeKey("messages")
		negotiationQuery.includeKey("sender")
		negotiationQuery.includeKey("listing")
		negotiationQuery.includeKey("listing.book")
		negotiationQuery.includeKey("listing.seller")
		negotiationQuery.includeKey("listing.buyer")
		//negotiationQuery.orderByAscending("Dat time ting")
		
		negotiationQuery.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]!, error: NSError!) -> Void in
			if error == nil {
				// The query succeeded. Pass the matching Listings to the callback function.
				if let negotiations = objects as? [Negotiation] {
					callback(negotiations)
				}
			}
		}
	}
	
	// Type method that searches the parse db for listings that match
	// the provided query. Accepts a callback function that is called when
	// the query is complete
	class func getListingNegotiation(listing: Listing, isSeller: Bool) -> Negotiation? {

        var search: String = "seller"
        
        if !isSeller {
            search = "buyer"
        }
		
		// Search for Negotiations where the user ID matches that of the current user
		var negotiationQuery = PFQuery(className: "Negotiation")
		negotiationQuery.whereKey("listing", equalTo:listing)
		negotiationQuery.whereKey(search, equalTo:PFUser.currentUser() as User)
		negotiationQuery.includeKey("messages")
		negotiationQuery.includeKey("buyer")
		negotiationQuery.includeKey("sender")
		negotiationQuery.includeKey("listing.seller")
		negotiationQuery.includeKey("listing.buyer")
		negotiationQuery.includeKey("listing.book")
		
		// TODO: order negotiations buy most recent message.
		//negotiationQuery.orderByAscending("")
		
		var negotiation = Negotiation()
		var results = negotiationQuery.findObjects()
		if (results.count > 1) {
			println("Something is wrong. Multiple negotiations found for buyer on listing: " + listing.objectId)
		} else if (results.count == 1) {
			negotiation = results[0] as Negotiation
		} else {
			// Create new Negotiation object
			negotiation.seller = listing.seller as User
			negotiation.buyer = UserController.getCurrentUser()
			negotiation.listing = listing
			negotiation.messages = []
		}
		
		return negotiation
	}
}