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
	
	let cellIdentifier: String = "ConversationCell"
	
	var conversationQuery:PFQuery!
	var conversations: [Conversation] = []
	var viewBuyerConversations:Bool!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		// Register delegates for conversation table view
		conversationTableView.delegate = self
		conversationTableView.dataSource = self
		
		viewBuyerConversations = true
		
		// Set the conversation query parameters
		updateConversationQuery()
		
		// Register timed callback the refreshes the conversation list every 5 seconds
		NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "reloadConversationViewTable:", userInfo: nil, repeats: true)
		
        conversationTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// Update the requirements for the conversation query
	func updateConversationQuery() {
		conversationQuery = PFQuery(className: "Conversation")
		conversationQuery.whereKey("buyer", equalTo:UserController.getCurrentUser())
		conversationQuery.includeKey("messages")
		conversationQuery.includeKey("sender")
		//conversationQuery.orderByAscending("Dat time ting")
	}
	
	// Callback that refreshes the conversation data.
	func reloadConversationViewTable(timer:NSTimer!) {
		var conversations = conversationQuery.findObjects()
		
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

		cell.bookTitleLabel?.text = "Test title"
		cell.newMessageIcon?.hidden = false
		return cell
	}
	
	// Mandatory UITableViewDelete function
	// Populates cells with message data
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		let row = indexPath.row
	}
}
