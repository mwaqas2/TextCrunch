//
//  ListingTableViewCell.swift
//  TextCrunch
//
//  Created by George Coomber on 2015-02-19.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
	@IBOutlet weak var listingImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
