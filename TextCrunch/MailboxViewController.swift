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
	@IBOutlet weak var negotiationTableView: UITableView!
	@IBOutlet weak var userSegmentControl: UISegmentedControl!
	
	let cellIdentifier: String = "NegotiationCell"
	
	var selectedNegotiation: Negotiation!
	var negotiationQuery:PFQuery!
	var negotiations: [Negotiation] = []
	var viewBuyerNegotiations:Bool!
	var timer: NSTimer!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Register delegates for negotiation table view
		negotiationTableView.delegate = self
		negotiationTableView.dataSource = self
		
		viewBuyerNegotiations = true
		
		// Register timed callback the refreshes the negotiation list every 5 seconds
		timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "reloadNegotiationViewTable:", userInfo: nil, repeats: true)
		
		NegotiationDatabaseController.getUserNegotiations(viewBuyerNegotiations, callback: updateNegotiations)
    }

    override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// Refresh the list of negotiations displayed in the TableView	
	func reloadNegotiationViewTable(timer:NSTimer!) {
		NegotiationDatabaseController.getUserNegotiations(viewBuyerNegotiations, callback: updateNegotiations)
	}
	
	// Callback function for Parse DB search. Called when
	// the query of the Parse DB is complete. Accepts a list of PFObjects
	// containing the results of the most recent query
	func updateNegotiations(queryResults: [Negotiation]) {
		negotiations = queryResults
		negotiationTableView.reloadData()
	}

	// Mandatory UITableViewDelete function
	// Returns number of rows in negotiationTableView
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return negotiations.count
	}
	
	// Mandatory UITableViewDelete function
	// Creates cell to be put into the TableView
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MailboxTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as MailboxTableViewCell

		let negotiation = negotiations[indexPath.row]
		let mostRecentMessage: Message? = negotiation.messages.last!
		
		cell.bookTitleLabel?.text = negotiation.listing.book.title
		cell.latestMessageLabel?.text = mostRecentMessage?.content
		
		cell.newMessageIcon?.hidden = false
		
		return cell
	}
	
	// Mandatory UITableViewDelete function
	// Called when tableView row is selected
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedNegotiation = negotiations[indexPath.row]
        
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		
		// Segue to a view of the selected listing
		self.performSegueWithIdentifier("ViewNegotiation", sender: nil)
	}
	
	// Called when the user selects a tab from the segment control. Switch between buyer
	// and seller negotiations
	@IBAction func onSegmentControlPressed(sender: AnyObject) {
		viewBuyerNegotiations = !viewBuyerNegotiations
		
		// Update the table view
		NegotiationDatabaseController.getUserNegotiations(viewBuyerNegotiations, callback: updateNegotiations)
	}
	
	// Called when the current view appears
	override func viewDidAppear(animated: Bool) {
		// Instantiate the timer if the timer has been destroyed
		if timer == nil {
			timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "reloadNegotiationViewTable:", userInfo: nil, repeats: true)
		}
	}
	
	// Called when the current view disappears
	override func viewDidDisappear(animated: Bool) {
		// Invalidate the timer when leaving the view
		if timer != nil {
			timer.invalidate()
			timer = nil
		}
	}
	
	// Called before seguing to another view
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "ViewNegotiation") {
			var svc = segue.destinationViewController as NegotiationViewController;
			// Hide back bar to avoid resubmission of listing
			// Only occurs when ViewListing is accessed via EditListing
			svc.negotiation = selectedNegotiation
			svc.listing = selectedNegotiation.listing
			svc.isNewListing = false
			svc.seguedFromMailbox = true
		} else if (segue.identifier == "LogoutSegue") {
			var test = 1
			test = 2
			test = 3 * test
		}
	}
}
