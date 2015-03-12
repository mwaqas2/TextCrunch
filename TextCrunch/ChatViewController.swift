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

class ChatViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var soldButton: UIButton!
    
	let cellIdentifier = "MessageCell"
	let MAX_MESSAGE_LENGTH = 200
	
	var listing: Listing!
	var conversation = Conversation()
	var conversationQuery = PFQuery(className: "Conversation")
	var isNewListing = true
	var isNewConversation = false
    var userIsSeller : Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		messageTextView.delegate = self
		messageTableView.delegate = self
		messageTableView.dataSource = self
		self.messageTableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
		
		// Do not autoscroll UITextViews within this view controller
		self.automaticallyAdjustsScrollViewInsets = false
		
		isNewConversation = false
		var bookTitle = ""
		if isNewListing {
			listing = Listing()
		}
		else {
			bookTitle = listing.book.title
		}
        var seller = listing.seller.fetchIfNeeded() as User
        userIsSeller = (seller.email == UserController.getCurrentUser().email)
        if(userIsSeller){
            userIsSeller = true
            holdButton.hidden = false
            soldButton.hidden = false
            if(listing.isOnHold){
                holdButton.setTitle("Remove Hold", forState: .Normal)
            } else {
                holdButton.setTitle("Hold", forState: .Normal)
            }
        }
		// Set navigation bar title
		self.title = bookTitle
		
		// Set message box boarder appearance
		self.messageTextView.layer.borderWidth = 2
		self.messageTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
		self.messageTextView.layer.cornerRadius = 8
		self.messageTextView.contentInset = UIEdgeInsetsMake(2.0, 1.0 , 0.0, 0.0)
        
		
		// If segue-ing from Inbox don't call this function, just pass in conversation object through via PrepareForSegue in the InboxViewController
		// TODO: Add statement to skip segueFromListing if segue-ing from Inbox
		getListingConversation()
		
		NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "reloadMessageViewTable:", userInfo: nil, repeats: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Callback for the UITextView that returns true if the text in the TextView should
	// be updated. Only allows the user to enter MAX_MESSAGE_LENGTH chars into the textbox
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		return countElements(messageTextView.text) + (countElements(text) - range.length) <= MAX_MESSAGE_LENGTH
	}
	
	// Check if conversation with this seller and listingId exsts
	// If not, create a new conversation
	func getListingConversation() {
		// Search for Conversations who's listing id matches that of the current listing
		conversationQuery.whereKey("listingId", equalTo:listing.objectId)
		conversationQuery.whereKey("buyer", equalTo:UserController.getCurrentUser())
		conversationQuery.includeKey("messages")
		conversationQuery.includeKey("sender")
		
		var results = conversationQuery.findObjects()
		if (results.count > 1) {
		    println("Something is wrong. Multiple conversations found for buyer on listing: " + listing.objectId)
		} else if (results.count == 1) {
		    conversation = results[0] as Conversation
		} else {
		    // Create new Conversation object
			conversation.seller = listing.seller as User
		    conversation.buyer = UserController.getCurrentUser()
		    conversation.listingId = listing.objectId
			conversation.messages = []
		}
	}
	
	// Sends a message between users when the send button is pressed
	@IBAction func onSendButtonClicked(sender: AnyObject) {
		var message = Message()
		message.sender = UserController.getCurrentUser()
		
		if (UserController.getCurrentUser() == conversation.seller) {
			message.receiver = conversation.buyer
		} else {
			message.receiver = conversation.seller
		}
		
		message.content = messageTextView.text
		conversation.messages.append(message)
		conversation.save()
		
		// Clear the textview when message is sent.
		messageTextView.text = ""
		messageTableView.reloadData()
	}
	
	func reloadMessageViewTable(timer:NSTimer!) {
		var results = conversationQuery.findObjects()
		if (results.count == 1) {
			conversation = results[0] as Conversation
			messageTableView.reloadData()
		}
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
		cell.backgroundColor = UIColor.clearColor()
		cell.selectionStyle = UITableViewCellSelectionStyle.None
		
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
    
    @IBAction func toggleListingHold(sender: AnyObject) {
        if(listing.isOnHold){
            listing.isOnHold = false
            listing.save()
            holdButton.setTitle("Hold", forState: .Normal)
        } else if (!listing.isOnHold){
            listing.isOnHold = true
            listing.save()
            holdButton.setTitle("Remove Hold", forState: .Normal)
        }
        return
    }
    
    
    @IBAction func onSoldButtonClicked(sender: AnyObject) {
        var alert = UIAlertController(title: "Mark as Sold", message: "Warning: Once you mark a listing as sold it will no longer show up in search results and this cannot be reversed. Continue?", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "I'm Sure", style: UIAlertActionStyle.Default, handler: {
            action in switch action.style{
            case .Default:
                self.listing.isActive = false
                self.listing.buyer = self.conversation.buyer
                self.listing.save()
                self.performSegueWithIdentifier("soldButtonSegue", sender: nil)
                break
            default:
                break
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
