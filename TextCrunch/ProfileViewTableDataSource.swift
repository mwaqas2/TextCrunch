//
//  ProfileViewTableDataSource.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-02-15.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


class ProfileViewTableDataSource: NSObject, UITableViewDataSource{
    
    let currentListings: [Listing] = []
    
    override init(){
        currentListings = UserController.getAllCurrentUsersListings()!
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentListings.count
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
            authorLabel.text = book.authorName
        }
        if let priceLabel = cell.viewWithTag(103) as? UILabel{
            if(listing.isActive == false){
                priceLabel.text = "Sold"
            } else {
                priceLabel.text = "$\(listing.price)"
            }
        }
        return cell
    }
}
