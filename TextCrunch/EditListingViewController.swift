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
    
    @IBOutlet var locationtext: UITextField!
    
    var bookISBN:String!
    var listing:Listing!
    
    var imageExist = false
    var data: NSData? = nil
    var json: JSON!
    var numberofbooks = 0;
	var isNewListing = false
    
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
            
            /*
            var locationstring = toString(locationtext)
            print("locationstring \(locationstring)")
            var escapedlocation = locationstring.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            
            print("escapedlocation \(escapedlocation)")

            
            
            var dictionarycoordinates:NSMutableArray = getCoordinates(escapedlocation!)
            
            print("dictionary location: \(dictionarycoordinates)")
            
            var gotoif = ((dictionarycoordinates[0]) as NSObject == true)
            print("gotoif \(gotoif)")
            if((dictionarycoordinates[0]) as NSObject == true){
                
                var lat:Double = dictionarycoordinates[1] as Double
                var lng:Double = dictionarycoordinates[2] as Double
                //let point = EditListingViewController.PFGeoPoint(latitude: CGFloat(lat), longitude: CGFloat(lng))
                
                var point:PFGeoPoint = PFGeoPoint(location: CLLocation(latitude: lat, longitude: lng)!)

                
                
                book["location"] = point
            
            }*/
            
            //let point = PFGeoPoint(latitude: CGFloat(3), CGFloat(3))

            
            //var numberofbooks = toString(json["totalItems"]).toInt()
            
            //let point = PFGeoPoint(latitude:40.0, longitude:-30.0)
            //book["location"] = point
            
            
            
            book.save()
            
            listing = Listing()
            listing.book = book
            listing.seller = UserController.getCurrentUser()
			listing.isActive = true
			listing.isOnHold = false
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
    
    func getCoordinates(address: String) -> NSMutableArray{

        let url = "https://maps.googleapis.com/maps/api/geocode/json?address="
        
        let urlandisbn = url+address
        
        println("urlandisbn \(urlandisbn)")
        
        json = JSON(url:urlandisbn)
        
        
        //so here we check if we can give them an address by a for loop
        
        //if yes grab the latitude and longitude
        
        
        var responsestatus =  toString(json["status"])
        
        var ourarray:NSMutableArray = [false,0,0,""]
        
        println(" responsestatus \(responsestatus)")
        var x = (responsestatus == "OK")
        println(" equal? \(x)")

        
        if (responsestatus == "OK"){
        
            var addressname = toString(json["results"][0]["formatted_address"])
            
            println(addressname)
            var longitude =  ((toString(json["results"][0]["geometry"]["location"]["lng"])) as NSString).floatValue
            var latitude =  (toString(json["results"][0]["geometry"]["location"]["lat"]) as NSString).floatValue
            
            println("types")
            
            print(json["results"].type)
            print(json["results"][0].type)
            print(json["results"][0]["geometry"]["location"].type)
            print(json["results"][0]["geometry"]["location"]["lng"].type)
            print(json["results"][0]["geometry"]["location"])
            
            //print("separate")
            //print(json["results"]["location"])


            
            println("types")

            
            print("longitude \(longitude)")
            print("longitude \(latitude)")

        
            ourarray[0] = true
            ourarray[1] = latitude
            ourarray[2] = longitude
            ourarray[3] = addressname

            

            
        }
        //var longitude =  toString(json["totalItems"]).toInt()
        //var latitude =  toString(json["totalItems"]).toInt()
        println("inside array \(ourarray)")
        //return bookcount!
        return ourarray
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
        book.title = bookTitle.text
        book.language = language.text
        book.authorName = author.text
        book.publisherName = publisher.text
        book.editionInfo = edition.text
        book.isbn13 = isbn13.text
		book.canonicalTitle = getCanonicalStrings(bookTitle.text)
		book.canonicalAuthor = getCanonicalStrings(author.text)
        book.save()
		
		listing = Listing()
        listing.book = book
        listing.seller = UserController.getCurrentUser()
        setBookElements(book)
    }
	
	// Functio that takes a string and returns an array of strings created
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
		if isNewListing {
			listing.isOnHold = false
			listing.isActive = true
		}
        
        
        var locationstring = toString(locationtext.text)
        print("locationstring \(locationstring)")
        var escapedlocation = locationstring.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        print("escapedlocation \(escapedlocation)")
        
        
        
        var dictionarycoordinates:NSMutableArray = getCoordinates(escapedlocation!)
        
        print("dictionary location: \(dictionarycoordinates)")
        
        var gotoif = ((dictionarycoordinates[0]) as NSObject == true)
        print("gotoif \(gotoif)")
        if((dictionarycoordinates[0]) as NSObject == true){
            
            var lat:Double = dictionarycoordinates[1] as Double
            var lng:Double = dictionarycoordinates[2] as Double
            //let point = EditListingViewController.PFGeoPoint(latitude: CGFloat(lat), longitude: CGFloat(lng))
            
            var point:PFGeoPoint = PFGeoPoint(location: CLLocation(latitude: lat, longitude: lng)!)
            
            var book = listing.book
            book["location"] = point
            
        }
        
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
			svc.isNewListing = isNewListing
        } else if (segue.identifier == "deleteListing") {
            var svc = segue.destinationViewController as IsbnViewController;
            //svc.listing = self.listing
            listing.book.delete()
            listing.delete()
        } else if (segue.identifier == "updateListing") {
            var svc = segue.destinationViewController as ListingViewController;
            svc.listing = self.listing
			svc.isNewListing = isNewListing
            
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