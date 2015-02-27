//
//  BookModel.swift
//  TextCrunch
//
//  Created by Erin Torbiak on 2015-02-06.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class Book : PFObject, PFSubclassing {
    
    @NSManaged var isbn13: String
    @NSManaged var title: String
    @NSManaged var language: String
    @NSManaged var authorName: String
    @NSManaged var publisherName: String
    @NSManaged var editionInfo: String
	
	// canonical fields for search keywords in lowercase
	@NSManaged var canonicalTitle: [String]
	@NSManaged var canonicalAuthor: [String]
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Book"
    }
}
