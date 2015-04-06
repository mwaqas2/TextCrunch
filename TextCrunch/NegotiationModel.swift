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
    
    override init() {
        super.init()
    }
    
    convenience init(email: String, stripeId: String = "") {
        self.init()
        
        self.completed = false
        self.isNewBuyerMessage = false
        self.isNewSellerMessage = false
        self.purchaseRequested = false
        self.paymentCaptureUrl = ""
    }
    
    func sendMessage(content: String, receiever: User, receiverIsSeller: Bool) {
        
        var message = Message()
        message.sender = UserController.getCurrentUser()
        message.content = content
        message.receiver = receiever
        
        // Update the negotiation's new message flags
        if receiverIsSeller {
            
            self.isNewSellerMessage = true
            
            if (self.messages.count == 0) {
                self.isNewBuyerMessage = false
            }
            
        } else {
            
            self.isNewBuyerMessage = true
            
            if (self.messages.count == 0) {
                self.isNewSellerMessage = false
            }
        }
        
        self.messages.append(message)
        self.save()
        
    }
}
