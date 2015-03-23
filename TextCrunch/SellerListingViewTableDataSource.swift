//
//  ProfileViewTableDataSource.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-02-15.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import UIKit

//This class is used as the data source for the main table in the seller's listing screen (SellerListingViewController).
class SellerListingViewTableDataSource: NSObject, UITableViewDataSource{
    
    enum DisplayType : Int {//Describes which listings should be shown to the user.
        case ALL = 0//Both active and inactive listings are shown.
        case ACTIVE//Only active listings are shown.
        case INACTIVE//Only inactive listings are shown.
        case NONE//No listings are shown.
    }
    
    var currentListings: [Listing] //Array of the current listings being shown to the user.
    var totalListings: [Listing] //All of the listings found associated with the user.
    var activeListings: [Listing] //The active listings found associated with the user.
    var inactiveListings: [Listing] //The inactive listings found associated with the user.
    var currentDisplay : DisplayType //Describes which combination of listing types the user wants to be shown.
    
    override init(){
        totalListings = UserController.getAllCurrentUsersListings()!
        totalListings.sort({
            $0.createdAt.compare($1.createdAt) == NSComparisonResult.OrderedAscending
        })
        currentListings = totalListings
        activeListings = []
        inactiveListings = []
        for listing in totalListings{
            if listing.isActive{
                activeListings.append(listing)
            } else {
                inactiveListings.append(listing)
            }
        }
        currentDisplay = .ALL
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentListings.count as Int
    }
    
    func modifyDisplay(newDisplay : DisplayType){
        switch newDisplay{
        case .ALL:
            currentListings = totalListings
            currentDisplay = .ALL
            break
        case .ACTIVE:
            currentListings = activeListings
            currentDisplay = .ACTIVE
            break
        case .INACTIVE:
            currentListings = inactiveListings
            currentDisplay = .INACTIVE
            break
        case .NONE:
            currentListings = []
            currentDisplay = .NONE
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("SellerListingCell", forIndexPath: indexPath) as UITableViewCell
        let listing = currentListings[indexPath.row] as Listing
        let book = listing.book.fetchIfNeeded() as Book//Since the book is in a relation, Parse does not automatically fetch it when we query for
        //all of the user's listings. So we need to fetch it if it is not available.
        if let titleLabel = cell.viewWithTag(101) as? UILabel{
            titleLabel.text = book.title
        }
        if let authorLabel = cell.viewWithTag(102) as? UILabel{
            authorLabel.text = "by \(book.authorName)"
        }
        if let priceLabel = cell.viewWithTag(103) as? UILabel{
            if(listing.isActive == false){
                priceLabel.text = "Sold"
            } else {
                priceLabel.text = "$\(listing.price)"
            }
        }
        if let imageThumb = cell.viewWithTag(100) as? UIImageView{
            imageThumb.frame = CGRectMake(0, 0, 100, 100)
            //Weird issues with the image thumbnail moving to the center of the cell, can't seem to fix in storyboard,
            //so the location is set here programmatically.
            //Maybe the view's width and height are changing rather than location?
            //TODO: Find a fix that doesn't require setting cell programmatically.
        }
        return cell
    }
    
    //Present because of strange memory issues. Instances would be deallocated despite strong references to them. GG swift.
    deinit{
        NSLog("The UITableViewDataSource has been deinitialized. This should not happen while the table is open.")
    }
}
