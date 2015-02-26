//
//  SearchViewController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-15.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource {
	
	// Enum representing the sorting state
	enum SortMode: Int{
		case None = 0
		case TitleInc
		case TitleDec
		case AuthorInc
		case AuthorDec
		case PriceInc
		case PriceDec
	}
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var listingTableView: UITableView!
	
	@IBOutlet weak var titleSortButton: UIButton!
	@IBOutlet weak var authorSortButton: UIButton!
	//@IBOutlet weak var priceSortButton: UIButton!
	
	@IBOutlet weak var titleUpArrow: UIImageView!
	@IBOutlet weak var titleDownArrow: UIImageView!
	@IBOutlet weak var authorDownArrow: UIImageView!
	@IBOutlet weak var authorUpArrow: UIImageView!
	//@IBOutlet weak var sortDownArrow: UIImageView!
	//@IBOutlet weak var sortUpArrow: UIImageView!
	
	// Array of Listings returned by a search
	var listings: [Listing] = []
	var currentSortMode: SortMode = SortMode.None
	var currentSearchKeywords: [String] = []
	var selectedListing: Listing!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		listingTableView.reloadData()
		
		// Update sort UI elements
		currentSortMode = SortMode.None
		updateSortArrows()
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listings.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: ListingTableViewCell = tableView.dequeueReusableCellWithIdentifier("ListingCell") as ListingTableViewCell
		
		let listing = listings[indexPath.row]
		let listingBook = listing.book
		
		// Set the cell's text and image
		cell.titleLabel?.text = listingBook.title
		cell.authorLabel?.text = "by " + listingBook.authorName
		cell.priceLabel?.text = "$ " + String(listing.price)
		
		// TODO: Add book image to cell
		
		let image = UIImage(named: "effective_cpp.jpeg")
		cell.listingImage.image = image
		
		return cell
	}
	
	
	// Callback function for Parse DB search. Called when
	// the query of the Parse DB is complete. Accepts a list of PFObjects
	// containing the results of the most recent query
	func updateListings (queryResults: [Listing]) {
		listings = queryResults
		listingTableView.reloadData()
	}
	
	
	// Parses the entered text from the search bar and returns an array of lower-case
	// strings representing the search keywords
	func getSearchKeywords () -> [String] {
		var keywords: [String] = []
		
		// Retrieve the strings in the input text separated by spaces
		var inputWords: [String] = searchBar.text.componentsSeparatedByString(" ")
		
		// Ensure all search words are lower case and that all search words are significant (ie. not "and", "the", etc.)
		for word:String in inputWords {
			if !isIgnoredWord(word) {
				keywords.append(word.lowercaseString)
			}
		}
		
		return keywords
	}
	
	
	// Checks if the current string is a word that should be ignored by the search
	// (for example "and", "or", "a", "the", etc.)
	func isIgnoredWord (word: String) -> Bool {
		return (word == "and")
			|| (word == "is")
			|| (word == "the")
			|| (word == "a")
			|| (word == "an")
	}
	
	// Updates the visibility of arrows indicating which sorting mode is active
	func updateSortArrows () {
		var hideTitleDown: Bool = true
		var hideTitleUp: Bool = true
		var hideAuthorDown: Bool = true
		var hideAuthorUp: Bool = true
		var hidePriceDown: Bool = true
		var hidePriceUp: Bool = true
		
		switch (currentSortMode) {
		case SortMode.TitleInc:
			hideTitleUp = false
			break
		case SortMode.TitleDec:
			hideTitleDown = false
			break
		case SortMode.AuthorInc:
			hideAuthorUp = false
			break
		case SortMode.AuthorDec:
			hideAuthorDown = false
			break
		case SortMode.PriceInc:
			hidePriceUp = false
			break
		case SortMode.PriceDec:
			hidePriceDown = false
			break
		default:
			break
		}

		titleDownArrow.hidden = hideTitleDown
		titleUpArrow.hidden = hideTitleUp
		authorDownArrow.hidden = hideAuthorDown
		authorUpArrow.hidden = hideAuthorUp
	}
	
	// Sorts the array of listings returned by the current search according to the
	// current search mode
	func sortListings () {
		switch (currentSortMode) {
		case SortMode.TitleInc:
			listings.sort({ $0.book.title > $1.book.title })
			break
		case SortMode.TitleDec:
			listings.sort({ $0.book.title < $1.book.title })
			break
		case SortMode.AuthorInc:
			listings.sort({ $0.book.authorName > $1.book.authorName })
			break
		case SortMode.AuthorDec:
			listings.sort({ $0.book.authorName < $1.book.authorName })
			break
		case SortMode.PriceInc:
			listings.sort({ $0.price > $1.price })
			break
		case SortMode.PriceDec:
			listings.sort({ $0.price < $1.price })
			break
		default:
			break
		}
		
		listingTableView.reloadData()
	}
	
	// Called when search button clicked action occurs. Queries the parse
	// database for active Listings that match the keywords given by the user in the
	// search bar
	@IBAction func onSearchButtonClicked(sender: UIButton) {
		// Update sort UI elements
		currentSortMode = SortMode.None
		updateSortArrows()
		
		currentSearchKeywords = getSearchKeywords()
		ListingDatabaseController.searchListings(currentSearchKeywords, callback: updateListings)
	}
	
	// Called when title sort button clicked action occurs. Sorts the query
	// results and update's the UI
	@IBAction func onTitleSortButtonClicked(sender: AnyObject) {
		if currentSortMode == SortMode.TitleDec {
			currentSortMode = SortMode.TitleInc
		} else {
			currentSortMode = SortMode.TitleDec
		}
		
		updateSortArrows()
		sortListings()
	}
	
	// Called when author sort button clicked action occurs. Sorts the query
	// results and update's the UI
	@IBAction func onAuthorSortButtonClicked(sender: AnyObject) {
		if currentSortMode == SortMode.AuthorDec {
			currentSortMode = SortMode.AuthorInc
		} else {
			currentSortMode = SortMode.AuthorDec
		}
		
		updateSortArrows()
		sortListings()
	}
	
	// Called when price sort button clicked action occurs. Sorts the query
	// results and update's the UI
	/*@IBAction func onPriceSortButtonClicked(sender: AnyObject) {
		if currentSortMode == SortMode.PriceDec {
			currentSortMode = SortMode.PriceInc
		} else {
			currentSortMode = SortMode.PriceDec
		}
		
		updateSortArrows()
		sortListings()
	}*/
	@IBAction func onPriceSortButtonClicked(sender: AnyObject) {
		if currentSortMode == SortMode.PriceDec {
			currentSortMode = SortMode.PriceInc
		} else {
			currentSortMode = SortMode.PriceDec
		}
		
		updateSortArrows()
		sortListings()
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// Get the row data for the selected row
		selectedListing = listings[indexPath.row]
		
		// Segue to a view of the selected listing
		self.performSegueWithIdentifier("ViewSearchListing", sender: nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "ViewSearchListing") {
			var svc = segue.destinationViewController as ListingViewController;
			// Hide back bar to avoid resubmission of listing
			// Only occurs when ViewListing is accessed via EditListing
			svc.listing = selectedListing
		}
	}
	
}
