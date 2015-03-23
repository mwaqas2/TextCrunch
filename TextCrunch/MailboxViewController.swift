//
//  MailboxViewController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-03-16.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class MailboxTableViewCell: UITableViewCell {
	@IBOutlet weak var bookTitleLabel: UILabel!
	@IBOutlet weak var latestMessageLabel: UILabel!
	@IBOutlet weak var newMessageIcon: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}

class MailboxViewController: UIViewController, 	UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var conversationTableView: UITableView!
	@IBOutlet weak var userSegmentControl: UISegmentedControl!
	
	let cellIdentifier: String = "ConversationCell"
	
	var selectedConversation: Conversation!
	var conversationQuery:PFQuery!
	var conversations: [Conversation] = []
	var viewBuyerConversations:Bool!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Register delegates for conversation table view
		conversationTableView.delegate = self
		conversationTableView.dataSource = self
		
		viewBuyerConversations = true
		
		// Register timed callback the refreshes the conversation list every 5 seconds
		NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "reloadConversationViewTable:", userInfo: nil, repeats: true)
		
		ConversationDatabaseController.getUserConversations(viewBuyerConversations, callback: updateConversations)
    }

    override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// Refresh the list of conversations displayed in the TableView	
	func reloadConversationViewTable(timer:NSTimer!) {
		ConversationDatabaseController.getUserConversations(viewBuyerConversations, callback: updateConversations)
	}
	
	// Callback function for Parse DB search. Called when
	// the query of the Parse DB is complete. Accepts a list of PFObjects
	// containing the results of the most recent query
	func updateConversations(queryResults: [Conversation]) {
		conversations = queryResults
		conversationTableView.reloadData()
	}

	// Mandatory UITableViewDelete function
	// Returns number of rows in conversationTableView
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversations.count
	}
	
	// Mandatory UITableViewDelete function
	// Creates cell to be put into the TableView
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MailboxTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as MailboxTableViewCell

		let conversation = conversations[indexPath.row]
		let mostRecentMessage: Message? = conversation.messages.last!
		
		cell.bookTitleLabel?.text = conversation.listing.book.title
		cell.latestMessageLabel?.text = mostRecentMessage?.content
		
		cell.newMessageIcon?.hidden = false
		
		return cell
	}
	
	// Mandatory UITableViewDelete function
	// Called when tableView row is selected
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedConversation = conversations[indexPath.row]
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		
		// Segue to a view of the selected listing
		self.performSegueWithIdentifier("ViewChat", sender: nil)
	}
	
	// Called when the user selects a tab from the segment control. Switch between buyer
	// and seller conversations
	@IBAction func onSegmentControlPressed(sender: AnyObject) {
		viewBuyerConversations = !viewBuyerConversations
		
		// Update the table view
		ConversationDatabaseController.getUserConversations(viewBuyerConversations, callback: updateConversations)
	}
	
	// Called before seguing to another view
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "ViewChat") {
			var svc = segue.destinationViewController as ChatViewController;
			// Hide back bar to avoid resubmission of listing
			// Only occurs when ViewListing is accessed via EditListing
			svc.conversation = selectedConversation
			svc.listing = selectedConversation.listing
			svc.isNewListing = false
			svc.seguedFromMailbox = true
		}
	}
}
