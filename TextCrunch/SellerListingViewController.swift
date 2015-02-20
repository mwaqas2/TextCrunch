//
//  ProfileViewController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-02.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class SellerListingViewController: UITableViewController {
    var currentListings = [Listing]()
    @IBOutlet weak var listingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back navigation button in this view
		self.navigationItem.setHidesBackButton(true, animated: true)
        
        currentListings = UserController.getAllCurrentUsersListings()!
        currentListings.sort({
            $0.createdAt.compare($1.createdAt) == NSComparisonResult.OrderedAscending
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentListings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SellerListingCell", forIndexPath: indexPath) as UITableViewCell
        
        let listing = currentListings[indexPath.row] as Listing
        let book = listing.book.fetchIfNeeded() as Book
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
