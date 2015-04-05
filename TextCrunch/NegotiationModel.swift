//
//  NegotiationModel.swift
//  TextCrunch
//
//  Created by Erin Torbiak on 2015-02-06.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class Negotiation : PFObject, PFSubclassing {
	
    @NSManaged var buyer: User
	@NSManaged var seller: User
	@NSManaged var messages: [Message]
	@NSManaged var listing: Listing
	@NSManaged var completed: Bool
    @NSManaged var purchaseRequested: Bool
	@NSManaged var isNewSellerMessage: Bool
	@NSManaged var isNewBuyerMessage: Bool
    @NSManaged var paymentCaptureUrl: String?
	
	override class func load() {
		self.registerSubclass()
	}
	
	class func parseClassName() -> String! {
		return "Negotiation"
	}
}
