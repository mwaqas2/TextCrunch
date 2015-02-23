//
//  ProfileViewController.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-02.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class SellerListingViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        tableDataSource = SellerListingViewTableDataSource()
        //We initialize the table's data source here because of some issues with
        //it being deallocated while the table was still active, causing a crash.
        //For an unknown reason the table view was not storing a strong reference to 
        //the data source and it was being unallocated.
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var listingTable: UITableView!
    
    @IBOutlet weak var sellButton: UIButton!
    
    var tableDataSource : SellerListingViewTableDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back navigation button in this views
		self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.listingTable!.dataSource = tableDataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        return
    }

}
