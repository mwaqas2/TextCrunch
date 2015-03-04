//
//  ChatViewController.swift
//  TextCrunch
//
//  Created by Ern on 2015-02-24.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//
// Pass in a listing() when you segue to this view, as we need the Seller and ListingId.
// It will then check database if a conversation already exists for that listing and this buyer
// If not it will create a new conversation

import UIKit
import Foundation

class ChatViewController : UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

/*
class ChatViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet var messagesTableView: UITableView!
	@IBOutlet var messageInput: UITextView!
	var listing = Listing()
	var conversation = Conversation()
	let cellIdentifier = "MessageCell"
	var query = PFQuery(className: "Conversation")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.messagesTableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
		
		// Add border to TextView to make it more obvious
		messageInput!.layer.borderWidth = 1
		messageInput!.layer.borderColor = UIColor.blueColor().CGColor
		
		// If segue-ing from Inbox don't call this function, just pass in conversation object through via PrepareForSegue in the InboxViewController
		// TODO: Add statement to skip segueFromListing if segue-ing from Inbox
		segueFromListing()
		
		NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "reloadMessageViewTable:", userInfo: nil, repeats: true)
	}
	
	// Check if conversation with this seller and listingId exsts
	// If not, create a new conversation
	func segueFromListing() {
		// UNCOMMENT THIS ONCE LISTINGS CAN BE VIEWED
		//query.whereKey("listingId", equalTo:listing.objectId)
		//query.whereKey("buyer", equalTo:UserController.getCurrentUser())
		//query.includeKey("messages")
		//query.includeKey("sender")
		
		//var results = query.findObjects()
		//if (results.count > 1) {
		//    println("Something is wrong. Multiple conversations found for buyer on listing: " + listing.objectId)
		//} else if (results.count == 1) {
		//    conversation = results[0] as Conversation
		//}else {
		//    // Create new Conversation object
		//    conversation.seller = listing.seller as User
		//    conversation.buyer = UserController.getCurrentUser()
		//    conversation.listingId = listing.objectId
		//    conversation.isActive = 1
		//}
		// END
		
		// TESTING DATA -- Use this until Inbox is created, as inbox should pass in Conversation object, or objectID
		query.whereKey("objectId", equalTo:"QFTirbJIZn")
		query.includeKey("messages")
		conversation = query.findObjects()[0] as Conversation
		
		// Code to create array of pointers to messages because who the hell knows how to do that manually.
		//var m1 = Message()
		//m1.receiver = conversation.buyer
		//m1.sender = conversation.seller
		//m1.content = "I want to buy this book, yo."
		//var m2 = Message()
		//m2.receiver = conversation.seller
		//m2.sender = conversation.buyer
		//m2.content = "Sounds good, meet me in the dark where the critters lies waiting."
		//conversation.messages = [m1, m2]
		//conversation.save()
		// END
	}
	
	func reloadMessageViewTable(timer:NSTimer!) {
		conversation = query.findObjects()[0] as Conversation
		messagesTableView.reloadData()
	}
	
	@IBAction func sendMessage(sender: AnyObject) {
		var message = Message()
		message.sender = UserController.getCurrentUser()
		
		if (UserController.getCurrentUser().email == conversation.seller) {
			message.receiver = conversation.buyer
		} else {
			message.sender = conversation.seller
		}
		
		message.content = messageInput.text
		conversation.messages.append(message as Message)
		conversation.save()
		// Clear the textview when message is sent.
		messageInput.text = ""
		messagesTableView.reloadData()
	}
	
	// Mandatory UITableViewDelete function
	// Returns number of rows in messagesTableView
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversation.messages.count
	}
	
	// Mandatory UITableViewDelete function
	// Creates cell to be put into the listview
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
		
		cell.textLabel?.sizeToFit()
		cell.textLabel?.numberOfLines = 0
		
		var content = conversation.messages[indexPath.row].content
		if (conversation.messages[indexPath.row].sender.objectId == UserController.getCurrentUser().objectId) {
			cell.textLabel?.textAlignment = NSTextAlignment.Right
			content += " >"
		} else {
			cell.textLabel?.textAlignment = NSTextAlignment.Left
			content = "< " + content
		}
		cell.textLabel?.text = content
		return cell
	}
	
	// Mandatory UITableViewDelete function
	// Populates cells with message data
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		let row = indexPath.row
		println(conversation.messages[row].content)
	}
}
*/