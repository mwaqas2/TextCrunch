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
    @IBOutlet var addPhoto: UIButton!
    
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
        if (UIImagePickerController.isSourceTypeAvailable(.Camera) == false){
            var alert = UIAlertController(title: "Error", message: "Error: You cannot take a photo without a camera.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            presentViewController(imagePicker, animated:true, completion: nil);
        }
    }
    

    @IBAction func attachLibraryPhoto(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated:true, completion: nil)
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
