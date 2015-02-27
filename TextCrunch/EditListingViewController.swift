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

    @IBOutlet var bookimage: UIImageView!
    @IBOutlet var bookTitle: UITextField!
    @IBOutlet var author: UITextField!
    @IBOutlet var edition: UITextField!
    @IBOutlet var publisher: UITextField!
    @IBOutlet var language: UITextField!
    @IBOutlet var isbn13: UITextField!

    @IBOutlet var price: UITextField!
    @IBOutlet var comments: UITextField!
    
    @IBOutlet var delete: UIButton!
    @IBOutlet var update: UIButton!
    
    var bookISBN:String!
    var listing:Listing!
    
    var imageExist = false
    var data: NSData? = nil
    var json: JSON!
    var numberofbooks = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (listing != nil){
            setListingElements()
            numberofbooks = 1
        }
        
        var title = ""
        var authors = ""
        var edition = ""
        var publisher = ""
        var language = ""
        var isbn_13 = ""
        var contentversion = ""
        //var numberofbooks = 0
        
        
        if (listing == nil){
            numberofbooks = getGoogleCount(bookISBN)
        }
        
        if (data != nil){
            bookimage!.frame = CGRectMake(31,31,136,140)
            bookimage.image = UIImage(data: data!)
            imageExist = true
        }
        
        
        if (numberofbooks>0 && (listing == nil)){
            //var bookdiction = json["totalItems"]
            var bookdictionary = json["items"][0]["volumeInfo"]
            //
            
            //title
            title = toString(bookdictionary["title"])
            
            //language
            language = toString(bookdictionary["language"])
            
            //contentVersion
            contentversion = toString(bookdictionary["contentVersion"])
            
            //publisher
            publisher = toString(bookdictionary["publisher"])
            
            //authors in an array!
            authors = toString(bookdictionary["authors"][0])
            
            //isbn13
            isbn_13 = toString(bookdictionary["industryIdentifiers"][1]["identifier"])
            
            //isbn10
            var isbn10 = toString(bookdictionary["industryIdentifiers"][0]["identifier"])
            
            imageExist = (bookdictionary["imageLinks"]["smallThumbnail"].asString) != nil
            
            if (imageExist){
                var smallthumbnail = toString(bookdictionary["imageLinks"]["smallThumbnail"])
                
                var largethumbnail = toString(bookdictionary["imageLinks"]["thumbnail"])
                
                let url = NSURL(string:"\(smallthumbnail)")
                
                data = NSData(contentsOfURL: url!) //make sure your image in this url does exist
                bookimage!.frame = CGRectMake(31,31,136,140)
                
                bookimage.image = UIImage(data: data!)
            }
        }
        
        // Set Background
        //let gradientLayer = BackgroundSetting()
        //let background = gradientLayer.background()
        //background.frame=self.view.bounds
        //self.view.layer.insertSublayer(background, atIndex: 0)
        
        
        if (listing == nil && numberofbooks > 0) {
            var book = Book()
            
            book.title = title
            book.language = language
            book.authorName = authors
            book.publisherName = publisher
            book.editionInfo = contentversion
            book.isbn13 = isbn_13
            book.save()
            
            listing = Listing()
            listing.book = book
            listing.seller = UserController.getCurrentUser()
            setBookElements(book)
            
            // Only show delete button if listing previously existed
            delete.hidden = true
            update.hidden = true
            
        } else if (numberofbooks>0) {
            listing.book.isbn13 = bookISBN
            setListingElements()
        }
        
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
    
    
    // returns the number of books in google books
    func getGoogleCount(theisbn: String) -> Int{
        
        // google rest api
        let url = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
        
        let urlandisbn = url+theisbn
        
        json = JSON(url:urlandisbn)
        var bookcount =  toString(json["totalItems"]).toInt()
        return bookcount!
    }
    
    
    func setListingElements() {
        
        price.text = String(listing.price)
        comments.text = listing.comment
        
        bookTitle!.text = listing.book.title
        author!.text = listing.book.authorName
        publisher!.text = listing.book.publisherName
        language!.text = listing.book.language
        edition!.text = listing.book.editionInfo
        isbn13!.text = listing.book.isbn13
        
        price!.text = String(listing.price)
        //condition.text = listing.condition
        comments!.text = listing.comment
    }
    
    func saveTextFieldsToModel(){
        var book = Book()
        println("were here")
        book.title = bookTitle.text
        book.language = language.text
        book.authorName = author.text
        book.publisherName = publisher.text
        book.editionInfo = edition.text
        book.isbn13 = isbn13.text
        book.save()
        listing = Listing()
        listing.book = book
        listing.seller = UserController.getCurrentUser()
        setBookElements(book)
    }
    
    @IBAction func updateListing(sender: AnyObject) {
        
        var priceLen = countElements(price.text)
        
        
        saveTextFieldsToModel()
        if (priceLen > 0){
            listing.price = price.text.toInt()!
        }else{
            listing.price = 0
        }
        //listing.condition = condition.text
        listing.comment = comments.text
        listing.save()
        
        self.performSegueWithIdentifier("updateListing", sender: nil)
        
    }
    
    @IBAction func deleteListingAction(sender: AnyObject) {
        self.performSegueWithIdentifier("deleteListing", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "viewListing") {
            var svc = segue.destinationViewController as ListingViewController;
            // Hide back bar to avoid resubmission of listing
            // Only occurs when ViewListing is accessed via EditListing
            svc.listing = self.listing
        }
        if (segue.identifier == "deleteListing") {
            var svc = segue.destinationViewController as IsbnViewController;
            //svc.listing = self.listing
            listing.book.delete()
            listing.delete()
        }
        if (segue.identifier == "updateListing") {
            var svc = segue.destinationViewController as ListingViewController;
            svc.listing = self.listing
            
            if (imageExist & (data != nil)){
                svc.data = data
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}