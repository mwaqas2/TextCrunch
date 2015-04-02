//
//  ListingDatabaseController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-21.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//
//	Controller that modifies and retrieves information from
//	the Parse database containing book listings.

import Foundation

class ListingDatabaseController {
	// Type method that searches the parse db for listings that match
	// the provided query. Accepts a callback function that is called when
	// the query is complete
	class func searchListings(searchKeywords: [String], sortByLocation: Bool, callback: ([Listing]) -> Void) {
		// TODO: add search by subject matter
		
		// Search for Listing with Books whose title matches the keywords
		var titleQuery = PFQuery(className: "Book")
		titleQuery.whereKey("canonicalTitle", containedIn: searchKeywords)
		
		// Search for Listing with Books whose author matches the keywords
		var authorQuery = PFQuery(className: "Book")
		authorQuery.whereKey("canonicalAuthor", containedIn: searchKeywords)
		
		// Search for Listing with Books whose isbn matches a keyword
		var isbnQuery = PFQuery(className: "Book")
		isbnQuery.whereKey("isbn13", containedIn: searchKeywords)
		
		var bookQuery =	PFQuery.orQueryWithSubqueries([titleQuery, authorQuery, isbnQuery])
		
		// Only consider book listings that are active (books that are currently for sale)
		var query = PFQuery(className: "Listing")
		query.whereKey("isActive", equalTo: true)
		query.whereKey("book", matchesQuery:bookQuery)
        
        //Only consider listings which are not on hold.
        query.whereKey("isOnHold", equalTo: false)
		
		// If results should be sorted by location, return results in ascending distance from
		// current user location
		if sortByLocation {
			let currentUser: User =  UserController.getCurrentUser() as User
			let userGeoPoint: PFGeoPoint! = currentUser["location"] as PFGeoPoint
			if userGeoPoint != nil {
				query.whereKey("location", nearGeoPoint: userGeoPoint)
			}
		}
		
		// Load the Book data for each Listing result of the query
		query.includeKey("book")
		query.includeKey("seller")
		query.includeKey("buyer")
		
		query.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]!, error: NSError!) -> Void in
			if error == nil {
				// The query succeeded. Pass the matching Listings to the callback function.
				if let listings = objects as? [Listing] {
					callback(listings)
				}
			}
		}
	}
    
    //Sets the passed in listing to be inactive.
    class func setInactive(listing: Listing) -> Void{
        listing.isActive = false
        listing.save()
        return
    }
    
    //Toggles the isOnHold state of the passed in listing.
    //After toggling the state, the method returns false if
    //the listing is no longer on hold, and true if the listing is
    //now on hold. Will return false as well if the listing's isOnHold wasn't
    //true or false for some reason. This should NEVER be the case.
    class func toggleHold(listing: Listing) -> Bool{
        if(listing.isOnHold == true){
            listing.isOnHold = false
            listing.save()
            return false
        } else if (listing.isOnHold == false){
            listing.isOnHold = true
            listing.save()
            return true
        } else {
            NSLog("Error: Could not toggle listing hold state because it was neither true nor false.")
            return false
        }
    }
    
    //Deletes the passed in listing from our database.
    class func deleteListing(listing: Listing) -> Void{
        //May need to change this in the future, but we don't need to do anything once
        //it starts getting deleted asynchronously for now.
        listing.deleteInBackgroundWithBlock({(result: Bool, error: NSError!) -> Void in
        })
        return
    }
	
	class func isListingOnHold(listingId: String, callback: (Bool) -> Void) {
		var listingQuery = PFQuery(className: "Listing")
		listingQuery.whereKey("objectId", equalTo:listingId)
		
		listingQuery.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]!, error: NSError!) -> Void in
			if error == nil {
				// The query succeeded. Pass the matching Listings to the callback function.
				if let listings = objects as? [Listing] {
					if listings.count > 0 {
						let listing = listings[0]
						callback(listing.isOnHold)
					}
				}
			}
		}
	}
}
