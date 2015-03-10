//
//  ListingViewController.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-10.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import UIKit

class ListingViewController: UIViewController {
    
    @IBOutlet var imageHolder: UIImageView!

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var edition: UILabel!
    @IBOutlet weak var isbn13: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var language: UILabel!
    
    @IBOutlet weak var editListing: UIButton!
    @IBOutlet weak var buy: UIButton!
    @IBOutlet weak var edit: UIButton!
	@IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var holdButton: UIButton!
    
    var listing:Listing!
    var data:NSData? = nil
	var isNewListing = false
    var userIsSeller : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let gradientLayer = BackgroundSetting()
        //let background = gradientLayer.background()
        //background.frame=self.view.bounds
        //self.view.layer.insertSublayer(background, atIndex: 0)
		
		self.navigationItem.setHidesBackButton(isNewListing, animated: true)
		doneButton.hidden = !isNewListing
		
        if (data != nil){
            imageHolder!.frame = CGRectMake(31,31,136,140)
            imageHolder.image = UIImage(data: data!)
        }
        
        // Shows edit button to seller, but not buy button
        // Shows buy button to potential buyer, but not edit button
        var listingSeller : User = listing.seller.fetchIfNeeded() as User
        userIsSeller = (UserController.getCurrentUser().email == listingSeller.email)
        if (userIsSeller) {
            buy.hidden = true
            if(listing.isOnHold){ holdButton.setTitle("Remove Hold", forState: .Normal)}
            else {holdButton.setTitle("Hold", forState: .Normal)}
        } else {
            edit.hidden = true
            removeButton.hidden = true
        }
        //Show hold button only is the viewing user is the listing's seller
        //and they're not looking at a new listing.
        holdButton.hidden = !(!isNewListing && userIsSeller)
        setListingElements()
    }
	
    // Populates labels with book/listing data
    func setListingElements() {
        bookTitle.text = "Title: \(listing.book.title)"
        author.text = "Author: \(listing.book.authorName)"
        publisher.text = "Publisher: \(listing.book.publisherName)"
        language.text = "Language: \(listing.book.language)"
        edition.text = "Edition: \(listing.book.editionInfo)"
        isbn13.text = "ISBN: \(listing.book.isbn13)"
        
        price.text = String(listing.price)
        condition.text = "Condition: \(listing.condition)"
        comments.text = listing.comment
    }
	
	@IBAction func EditListingButton(sender: AnyObject) {
		self.performSegueWithIdentifier("editListing", sender: nil)
	}
	
	// Segues to the Seller home page when Done button pressed
	@IBAction func onDoneButtonClicked(sender: AnyObject) {
		self.performSegueWithIdentifier("toSellerHomepage", sender: nil)
	}
	
	@IBAction func onChatButtonClicked(sender: AnyObject) {
		self.performSegueWithIdentifier("chat", sender: nil)
	}
    
    @IBAction func onRemoveButtonClicked(sender: AnyObject) {
        var alert = UIAlertController(title:"Remove Listing", message: "Warning: A listing is gone forever if you choose to remove it. Are you sure you want to remove this listing?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "I'm Sure", style: UIAlertActionStyle.Default,handler: {
            action in switch action.style{
            case .Default:
                NSLog("I'm Sure button pressed.")
                //Don't need to do anything while this runs for now.
                ListingDatabaseController.deleteListing(self.listing)
                self.performSegueWithIdentifier("toSellerHomepage", sender: nil)
                break
            default:
                break
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onHoldButtonClicked(sender: AnyObject) {
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
    
    // Passes listing to to Edit Listing View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editListing") {
            var svc = segue.destinationViewController as EditListingViewController;
            
            if (data != nil){
                //image data
                svc.data = data
            }
            
            svc.bookISBN = self.listing.book.isbn13
            svc.listing = self.listing
			svc.isNewListing = false
        }
		else if (segue.identifier == "chat") {
			var svc = segue.destinationViewController as ChatViewController;
			svc.listing = listing
			svc.isNewListing = false
		}
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}