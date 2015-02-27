//
//  IsbnViewController.swift
//  TextCrunch
//
//  Created by Kevin De Asis on 2015-02-10.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation
import UIKit

class IsbnViewController: UIViewController {
    
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet var InputLengthWarning: UILabel!
    
    @IBAction func SearchBooksButton(sender: AnyObject) {
        if checkIsbnInput(){
            self.performSegueWithIdentifier("searchBookIsbn", sender: nil)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide warnings
        showISBNWarning(true)
        
        //let gradientLayer = BackgroundSetting()
        //let background = gradientLayer.background()
        //background.frame=self.view.bounds
        //self.view.layer.insertSublayer(background, atIndex: 0)
        
    }
    
    //We check the isbn textbos if the length of the input is 10 or 13
    func checkIsbnInput() -> Bool {
        //var nonEmptyIsbn = !isbn.text.isEmpty
        var IsbnTextLength = countElements(isbn.text)
        var isCorrectIsbnLength = (((IsbnTextLength == 13) || (IsbnTextLength == 10) ))
        
        
        let url = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
        let urlandisbn = url+isbn.text
        let json = JSON(url:urlandisbn)
        
        var numberofbooks = toString(json["totalItems"]).toInt()
        
        // Looks to check if the length textfield of Isbn is 10 or 13
        // It doesnt matter if there are non-integer input we can still search for them and it doesnt cause a major issue
        // Also Isbn10 sometimes takes in letters
        if (isCorrectIsbnLength){
            return true
        }
        showISBNWarning(false)
        
        return false
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showISBNWarning(containsResults: Bool) {
        InputLengthWarning.hidden = containsResults
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if ((segue.identifier == "searchBookIsbn")/* && checkIsbnInput()*/) {
            var svc = segue.destinationViewController as EditListingViewController;
            svc.bookISBN = isbn.text
			svc.isNewListing = true
            
        }
    }
    
}