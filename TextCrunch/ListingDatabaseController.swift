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
	class func searchListings(searchKeywords: [String], callback: ([Listing]) -> Void) {
		
		// TODO: change title and author search to use canonical values
		
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
		
		// Load the Book data for each Listing result of the query
		query.includeKey("book")
		
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
}
