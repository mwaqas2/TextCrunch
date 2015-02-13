//
//  ListingModel.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-02-04.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class Listing : PFObject, PFSubclassing {
    @NSManaged var book: Book
    @NSManaged var price: Int
    @NSManaged var seller: PFObject
    @NSManaged var buyer: PFObject?
    @NSManaged var conversation: PFObject?
    @NSManaged var condition: String?
    @NSManaged var comment: String?

    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Listing"
    }
}
