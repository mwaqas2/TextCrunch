//
//  BookModel.swift
//  TextCrunch
//
//  Created by Erin Torbiak on 2015-02-06.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import CoreLocation

class Book {
    
    var isbn13: String
    var title: String
    var language: String
    var publisherName: String
    var editionInfo: String
    
    init(isbn13: String, title: String, language: String, publisherName: String, editionInfo: String) {
        self.isbn13 = isbn13
        self.title = title
        self.language = language
        self.publisherName = publisherName
        self.editionInfo = editionInfo
    }
}
