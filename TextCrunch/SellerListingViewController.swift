//
//  ProfileViewController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-02.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class SellerListingViewController: UIViewController, UITableViewDelegate{

    @IBOutlet weak var inactiveSwitch: UISwitch!//Switch for displaying inactive listings.
    @IBOutlet weak var activeSwitch: UISwitch!//Switch for displaying active listings.
    @IBOutlet weak var listingTable: UITableView!//The table view used to display all of the listings.
    @IBOutlet weak var sellButton: UIButton!//The button used to segue the user to a screen for selling listings.
    
    var tableDataSource : SellerListingViewTableDataSource//Custom class implementing UITableViewDataSource.
    var selectedListing: Listing?//The listing a user presses on. When pressed the user is segued to the listing screen for this listing.
    
    
    required init(coder aDecoder: NSCoder) {
        selectedListing = nil
        tableDataSource = SellerListingViewTableDataSource()
        //We initialize the table's data source here because of some issues with
        //it being deallocated while the table was still active, causing a crash.
        //For an unknown reason the table view was not storing a strong reference to
        //the data source and it was being unallocated.
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back navigation button in this views
		self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.listingTable!.dataSource = tableDataSource
        self.listingTable!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method required by UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedListing = tableDataSource.currentListings[indexPath.row]
        self.performSegueWithIdentifier("SellerViewCell", sender: nil)
    }
	
	// Called when the "Sell" button is clicked. Transitions to the screen for adding
	// user payment information or the screen to create a listing
	@IBAction func onSellButtonClicked(sender: AnyObject) {
		//TODO: Add a check to see if payment info has been added
		// if no payment info, go to payment info page, if payment info has already been
		// given, transition to the listing creation page.
		self.performSegueWithIdentifier("StartListingCreation", sender: nil)
	}
    
    //Called when either the inactiveSwitch or activeSwitch are pressed.
    @IBAction func switchClicked(sender: AnyObject) {
        if inactiveSwitch.on && activeSwitch.on{
            tableDataSource.modifyDisplay(.ALL)
        } else if inactiveSwitch.on && !activeSwitch.on{
            tableDataSource.modifyDisplay(.INACTIVE)
        } else if !inactiveSwitch.on && activeSwitch.on {
            tableDataSource.modifyDisplay(.ACTIVE)
        } else if !inactiveSwitch.on && !activeSwitch.on{
            tableDataSource.modifyDisplay(.NONE)
        }
        listingTable.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SellerViewCell") {
            var svc = segue.destinationViewController as ListingViewController;
            svc.listing = selectedListing
			svc.isNewListing = false
        }
        super.prepareForSegue(segue, sender: sender)
    }



}
