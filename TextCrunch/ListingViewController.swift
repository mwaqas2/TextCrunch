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
	
    var listing:Listing!
    var data:NSData? = nil
	var isNewListing = false

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
        if (UserController.getCurrentUser() == listing.seller) {
            buy.hidden = true
        } else {
            edit.hidden = true
        }
        
        setListingElements()
    }
	
    // Populates labels with book/listing data
    func setListingElements() {
        bookTitle.text = listing.book.title
        author.text = listing.book.authorName
        publisher.text = listing.book.publisherName
        language.text = listing.book.language
        edition.text = listing.book.editionInfo
        isbn13.text = listing.book.isbn13
        
        price.text = String(listing.price)
        condition.text = listing.condition
        comments.text = listing.comment
    }
	
	@IBAction func EditListingButton(sender: AnyObject) {
		self.performSegueWithIdentifier("editListing", sender: nil)
	}
	
	// Segues to the Seller home page when Done button pressed
	@IBAction func onDoneButtonClicked(sender: AnyObject) {
		self.performSegueWithIdentifier("DoneViewingListing", sender: nil)
	}
    
    // Passes listing to to Edit Listing View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editListing") {
            var svc = segue.destinationViewController as EditListingViewController;
            
            if (data != nil){
                //image data
                svc.data = data
            }
            
            svc.bookISBN = self.isbn13.text
            svc.listing = self.listing
			svc.isNewListing = false
        }
		else if (segue.identifier == "chat") {
			var svc = segue.destinationViewController as EditListingViewController;
			svc.listing = listing
		}
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}