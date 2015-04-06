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
	@NSManaged var condition: Int
    @NSManaged var comment: String?
    @NSManaged var isActive: Bool
    @NSManaged var isOnHold: Bool
    @NSManaged var image: PFFile?
    @NSManaged var thumbnail: PFFile?

    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Listing"
    }
}
