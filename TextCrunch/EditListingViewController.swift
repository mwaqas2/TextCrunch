//
//  EditListingViewController.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-10.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class EditListingViewController: UIViewController {
	
    @IBOutlet var bookImageButton: UIButton!
    //@IBOutlet var bookimage: UIImageView! //Image view displaying a thumbnail of the image attached to a listing.
    @IBOutlet var bookTitle: UITextField! //Label of the book title.
    @IBOutlet var author: UITextField! //Label of the book's authour.
    @IBOutlet var edition: UITextField! //Label of the book's edition.
    @IBOutlet var publisher: UITextField! //Label of the book's publisher.
    @IBOutlet var language: UITextField! //Label for the language the book is in.
    @IBOutlet var isbn13: UITextField! //Label for the ISBN13 attached to the book.

    @IBOutlet var price: UITextField! //Label for the price attached to the listing.
    @IBOutlet var comments: UITextField! //Label for any comments attached to the listing.
    
    //@IBOutlet var attachPhotoButton: UIButton!

	@IBOutlet weak var locationText: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var bookISBN:String!
    var listing:Listing!

    var imageExist = false
    var data: NSData? = nil
    var json: JSON!
    var numberofbooks = 0
	var isNewListing = false //Set to true before segue if a new listing is being editted rather than one that already exists.
    
    var GpsAddr = GpsAddress()
    var lat_float = 53.544389
    var long_float = -113.4909267
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pentagon.png")!)
        if (self.listing != nil){
            setListingElements()
            self.numberofbooks = 1
        } else {
            self.numberofbooks = getGoogleCount(self.bookISBN)
        }
        initializeGeopoint()
        if ((self.listing == nil) && (self.numberofbooks > 0)){
            initializeListing()
        } else if (self.numberofbooks > 0) {
            self.listing.book.isbn13 = bookISBN
            setListingElements()
        }
            //self.bookimage!.frame = CGRectMake(31,31,136,140)
    }
    
    
    //Sets text labels according to the passed in Book.
    func setBookElements(book: Book){
        bookTitle.text = book.title
        author.text = book.authorName
        publisher.text = book.publisherName
        language.text = book.language
        edition.text = book.editionInfo
        isbn13.text = book.isbn13
    }
    
    
    
    //Returns the number of books in google books
    func getGoogleCount(theisbn: String) -> Int{
        // google rest api
        let url = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
        let urlandisbn = url+theisbn
        json = JSON(url:urlandisbn)
        var bookcount =  toString(json["totalItems"]).toInt()
        return bookcount!
    }
    
    
    //Sets text labels according to the book attached to the current listing.
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
        comments!.text = listing.comment
        if(listing.image != nil){
            bookImageButton.setImage(UIImage(data: listing.image!.getData()), forState: .Normal)
            imageExist = true
        } else if (data != nil && listing.image == nil){
            bookImageButton.setImage(UIImage(data: data!), forState: .Normal)
            imageExist = true
            listing.image = PFFile(name: "image", data: data)
            listing.save()
        }
    }
    
    
    //Saves the values in the different text fields to the book model.
    func saveTextFieldsToModel(){
        var book : Book = self.listing.book.fetchIfNeeded() as Book
        book.title = bookTitle.text
        book.language = language.text
        book.authorName = author.text
        book.publisherName = publisher.text
        book.editionInfo = edition.text
        book.isbn13 = isbn13.text
        book.canonicalTitle = getCanonicalStrings(bookTitle.text)
        book.canonicalAuthor = getCanonicalStrings(author.text)
        book.save()
    }
	
    
    
	// Function that takes a string and returns an array of strings created
	// by parsing the input case and setting the string to lower cased.
	// Useful for retrieving arrays of keywords for book search.
	func getCanonicalStrings(inputString: String) -> [String] {
		var outputStrings: [String] = []
		
		// Retrieve the strings in the input string separated by spaces
		var inputWords: [String] = inputString.componentsSeparatedByString(" ")
		
		// Ensure all output words are lower case
		for word:String in inputWords {
			outputStrings.append(word.lowercaseString)
		}
		
		return outputStrings
	}
    
    //Initializes the elements of a new listing according the values fetched by our JSON query.
    func initializeListing(){
        var bookdictionary = json["items"][0]["volumeInfo"]
        var title = toString(bookdictionary["title"])
        var language = toString(bookdictionary["language"])
        var contentversion = toString(bookdictionary["contentVersion"])
        var publisher = toString(bookdictionary["publisher"])
        var authors = toString(bookdictionary["authors"][0])
        var isbn_13 = toString(bookdictionary["industryIdentifiers"][1]["identifier"])
        var isbn10 = toString(bookdictionary["industryIdentifiers"][0]["identifier"])
        
        self.imageExist = (bookdictionary["imageLinks"]["smallThumbnail"].asString) != nil
        if (self.imageExist){
            var smallthumbnail = toString(bookdictionary["imageLinks"]["smallThumbnail"])
            var largethumbnail = toString(bookdictionary["imageLinks"]["thumbnail"])
            let url = NSURL(string:"\(smallthumbnail)")
            self.data = NSData(contentsOfURL: url!) //make sure your image in this url does exist
            //self.bookimage!.frame = CGRectMake(31,31,136,140)
            //self.bookimage.image = UIImage(data: data!)
            self.bookImageButton.setImage(UIImage(data: data!), forState: .Normal)
        }
        var book = Book()
        book.title = title
        book.language = language
        book.authorName = authors
        book.publisherName = publisher
        book.editionInfo = contentversion
        book.isbn13 = isbn_13
        book.save()
        self.listing = Listing()
        self.listing.book = book
        self.listing.seller = UserController.getCurrentUser()
        self.listing.isActive = true
        self.listing.isOnHold = false
        self.listing.image = PFFile(name: "image", data: self.data)
        setBookElements(book)
        updateButton.hidden = true
    }
    
    
    //Initializes location data asynchronously.
    func initializeGeopoint(){
        var userlocation =  UserController.getCurrentUser()
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                self.lat_float = (geoPoint.latitude)
                self.long_float = (geoPoint.longitude)
                self.locationText.text = (self.GpsAddr.getAddress(toString(geoPoint.latitude), lng: toString (geoPoint.longitude)))
                // do something with the new geoPoint
            }
        }
    }
    
    
    
    @IBAction func updateListing(sender: AnyObject) {
        var priceLen = countElements(price.text)
        saveTextFieldsToModel()
        if (priceLen > 0){
            self.listing.price = price.text.toInt()!
        }else{
            self.listing.price = 0
        }
        self.listing.comment = self.comments.text
		if self.isNewListing {
			self.listing.isOnHold = false
			self.listing.isActive = true
		}

        /* uncomment
        if you want to update your listing location based 
        on new address place in textbox
        
        var address = Location.text
        var coord = GpsAddr.getCoordinates(address)
        print(coord)
        var coordArr = coord.componentsSeparatedByString(",")
        var newlat = (coordArr[0] as NSString).floatValue
        var newlong = (coordArr[1] as NSString).floatValue
        self.late_float = newlat
        self.lat_float = newlong
        */
        
        var point:PFGeoPoint = PFGeoPoint(location: CLLocation(latitude: self.lat_float, longitude: self.long_float)!)
        
        self.listing["location"] = point
        
        self.listing.save()
        //print(self.listing)//Why do we have a print here?
        self.performSegueWithIdentifier("updateListing", sender: nil)
        
    }
    
    @IBAction func imageButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("photoAttachSegue", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "viewListing") {
            var svc = segue.destinationViewController as ListingViewController;
            // Hide back bar to avoid resubmission of listing
            // Only occurs when ViewListing is accessed via EditListing
            svc.listing = self.listing
			svc.isNewListing = isNewListing
        } else if (segue.identifier == "deleteListing") {
            var svc = segue.destinationViewController as IsbnViewController;
            listing.book.delete()
            listing.delete()
        } else if (segue.identifier == "updateListing") {
            var svc = segue.destinationViewController as ListingViewController;
            svc.listing = self.listing
			svc.isNewListing = isNewListing
            if (imageExist && (data != nil)){
                svc.data = data
            }
        } else if (segue.identifier == "photoAttachSegue"){
            var svc = segue.destinationViewController as TakePictureViewController
            svc.listing = self.listing
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}