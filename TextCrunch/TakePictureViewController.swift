//
//  TakePictureViewController.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-03-28.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation

class TakePictureViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var takePhoto: UIButton!
    @IBOutlet var attachPhoto: UIButton!
    
    var listing: Listing!
    var data : NSData!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(listing.image != nil){
            imageView.image = UIImage(data: listing.image!.getData())
        } else {
            attachPhoto.hidden = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        attachPhoto.hidden = false
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated:true, completion: nil);
    }
    
    @IBAction func attachPhoto(sender: AnyObject) {
        //listing.image = PFFile(data: UIImagePNGRepresentation(imageView.image))
        listing.image = PFFile(data: UIImageJPEGRepresentation(imageView.image, 0.5))
        listing.save()
        self.performSegueWithIdentifier("imageAttachedSegue", sender: nil)
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "imageAttachedSegue"){
            var svc = segue.destinationViewController as EditListingViewController
            svc.listing = self.listing
            var book = self.listing.book.fetchIfNeeded() as Book
            svc.bookISBN = book.isbn13 //EditListingViewController is a confusing mess that drastically needs attention.
        }
    }
}
