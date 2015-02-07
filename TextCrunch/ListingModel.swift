//
//  ListingModel.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-02-04.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class ListingModel {
    var book: Book?
    var price: IntegerLiteralType
    var seller: UserModel?
    var buyer: UserModel?
    var conversation: Conversation?
    var condition: String
    var comment: String
    
    init(book: Book?, seller: UserModel?, price: IntegerLiteralType, condition: String, comment: String) {
        self.book = book
        self.seller = seller
        self.price = price
        self.condition = condition
        self.comment = comment
    }
}
