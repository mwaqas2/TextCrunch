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
    
    @IBOutlet var imageHolder: UIImageView!//UIImageView showing a thumbnail of the image attached to the listing.

    @IBOutlet weak var price: UILabel!//UILabel for the selected Listing's price.
    @IBOutlet weak var condition: UILabel!//UILabel for the selected Listing's condition.
    @IBOutlet weak var bookTitle: UILabel!//UILabel for the selected Listing's title.
    @IBOutlet weak var author: UILabel!//UILabel for the selected Listing's authour.
    @IBOutlet weak var publisher: UILabel!//UILabel for the selected Listing's publisher.
    @IBOutlet weak var edition: UILabel!//UILabel for the selected Listing's edition.
    @IBOutlet weak var isbn13: UILabel!//UILabel for the selected Listing's ISBN number.
    @IBOutlet weak var comments: UILabel!//UILabel for any comments attached to the Listing.
    @IBOutlet weak var language: UILabel!//UILbael for the language the book attached to the listing is in.
    
    @IBOutlet weak var chatButton: UIButton!//Button that segues the User to a screen for chatting with the Listing's seller.
    @IBOutlet weak var edit: UIButton!//Button that segues the User to a screen for editting a listing.
	@IBOutlet weak var doneButton: UIButton!//Button that the user presses to indicate they are done editting a listing.
    @IBOutlet weak var removeButton: UIButton!//Button that the user presses to delete the listing.
    @IBOutlet weak var holdButton: UIButton!//Button that the user presses to toggle whether or not there is a hold on the listing.
    
    var listing:Listing!//The listing being displayed to the user.
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
        var listingSeller : User = listing.seller.fetchIfNeeded() as User
        userIsSeller = (UserController.getCurrentUser().email == listingSeller.email)
        initializeViews()
        setListingElements()
    }
    
    //Sets up the state of the non-label views of the ListingView screen.
    func initializeViews(){
        doneButton.hidden = !isNewListing
        if (data != nil){
            imageHolder!.frame = CGRectMake(31,31,136,140)
            imageHolder.image = UIImage(data: data!)
        }
        
        // Shows edit button to seller, but not buy button
        // Shows buy button to potential buyer, but not edit button
        
        if (userIsSeller) {
            chatButton.hidden = true
            if(listing.isOnHold){
                holdButton.setTitle("Remove Hold", forState: .Normal)
            } else {
                holdButton.setTitle("Hold", forState: .Normal)
            }
        } else {
            edit.hidden = true
            removeButton.hidden = true
        }
        //Show hold button only is the viewing user is the listing's seller
        //and they're not looking at a new listing.
        holdButton.hidden = !(!isNewListing && userIsSeller)
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
	
    //Called when the button for editing a listing is pressed.
	@IBAction func EditListingButton(sender: AnyObject) {
		self.performSegueWithIdentifier("editListing", sender: nil)
	}
	
	// Segues to the Seller home page when Done button pressed
	@IBAction func onDoneButtonClicked(sender: AnyObject) {
		self.performSegueWithIdentifier("toSellerHomepage", sender: nil)
	}
	
    //Called when the chat button is pressed.
	@IBAction func onChatButtonClicked(sender: AnyObject) {
		self.performSegueWithIdentifier("chat", sender: nil)
	}
    
    
    //Called when the listing removal button is pressed.
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
        ListingDatabaseController.toggleHold(self.listing)
        if(listing.isOnHold){
            holdButton.setTitle("Remove Hold", forState: .Normal)
        } else if (!listing.isOnHold){
            holdButton.setTitle("Hold", forState: .Normal)
        }
        return
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editListing") {
            // Passes listing to to Edit Listing View Controller
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