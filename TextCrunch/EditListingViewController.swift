//
//  EditListingViewController.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-10.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import UIKit

class EditListingViewController: UIViewController {

    // Non-editable labels regarding book info
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var edition: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var isbn13: UILabel!
    @IBOutlet weak var language: UILabel!
   
    // Listing related input
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var comments: UITextField!

    @IBOutlet var delete: UIButton!
    
    var bookISBN:String!
    var listing:Listing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set Background
        //let gradientLayer = BackgroundSetting()
        //let background = gradientLayer.background()
        //background.frame=self.view.bounds
        //self.view.layer.insertSublayer(background, atIndex: 0)
        
        var book = Book()
        // Below is testing code until we get the ISBNDB stuff set up
        book.title = "Principles of solid mechanics"
        book.language = "english"
        book.authorName = "Richards, Rowland"
        book.publisherName = "CRC Press"
        book.editionInfo = "3rd Edition, (alk. paper)"
        book.save()
        // END
        
        if(listing == nil) {
            //TODO Populate book object with ISBNDB data
            book.isbn13 = bookISBN
            listing = Listing()
            listing.book = book
            listing.seller = UserController.getCurrentUser()
            
            // Only show delete button if listing previously existed
            delete.hidden = true
        } else {
            book.isbn13 = listing.book.isbn13
            setListingElements()
        }
        setBookElements(book)
    }
    
    func setBookElements(book: Book){
        // Load listing data into labels
        //labels.text = "TEXT BOOK"
        bookTitle.text = book.title
        author.text = book.authorName
        publisher.text = book.publisherName
        language.text = book.language
        edition.text = book.editionInfo
        isbn13.text = book.isbn13
    }
    
    func setListingElements() {
        price.text = String(listing.price)
        comments.text = listing.comment
    }

    @IBAction func updateListing(sender: AnyObject) {
        listing.price = price.text.toInt()!
        //listing.condition = condition.text
        listing.comment = comments.text
        listing.save()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "viewListing") {
            var svc = segue.destinationViewController as ListingViewController;
            // Hide back bar to avoid resubmission of listing
            // Only occurs when ViewListing is accessed via EditListing
            svc.listing = self.listing
        }
        if (segue.identifier == "deleteListing") {
            listing.delete()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}