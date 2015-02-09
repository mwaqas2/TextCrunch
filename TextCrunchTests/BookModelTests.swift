//
//  BookModelTests.swift
//  TextCrunch
//
//  Created by Erin Torbiak on 2015-02-07.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import UIKit
import XCTest

import TextCrunch

class BookModelTests : XCTestCase {

    override func setUp() {
        super.setUp()
        Parse.setApplicationId("bd9pkI4jclGiICv1xM5YQiDfsxUD4SB4c3jQvBHW", clientKey: "nyPjmHMJAacFQVQSg7CTxZj3DWp1pKW9RBVsOPGK")
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreateBook(){
        var book = Book()
        book.isbn13 = "9782001234567"
        book.title = "Textbook Title"
        book.language = "english"
        book.authorName = "Author Man"
        book.publisherName = "Publisher Dude"
        book.editionInfo = "3rd Edition"
        book.save()
        XCTAssert(book.isbn13 == "9782001234567" &&
            book.title == "Textbook Title" &&
            book.language == "english" &&
            book.authorName == "Author Man" &&
            book.publisherName == "Publisher Dude" &&
            book.editionInfo == "3rd Edition", "Parse working for Book model.")
        book.delete()
    }
}
