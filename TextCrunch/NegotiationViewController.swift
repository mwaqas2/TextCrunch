//
//  NegotiationViewController.swift
//  TextCrunch
//
//  Created by Ern on 2015-02-24.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//
// Pass in a listing() when you segue to this view, as we need the Seller and ListingId.
// It will then check database if a negotiation already exists for that listing and this buyer
// If not it will create a new negotiation

import UIKit
import Foundation

class MessageTableViewCell: UITableViewCell {
	@IBOutlet weak var receiverImageView: UIView!
	@IBOutlet weak var senderImageView: UIImageView!
	@IBOutlet weak var receiverTextView: UITextView!
	@IBOutlet weak var recipientImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: false)
		
		// Configure the view for the selected state
	}
	
}

class NegotiationViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, PayPalFuturePaymentDelegate {
    
    let installation = PFInstallation.currentInstallation()
    let pushQuery = PFInstallation.query()
    
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var soldButton: UIButton!
	@IBOutlet weak var buyerHoldWarningLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
	let cellIdentifier = "NegotiationMessageCell"
	let MAX_MESSAGE_LENGTH = 200
	
	var listing: Listing!
	var negotiation = Negotiation()
	var isNewListing = true
	var isNewNegotiation = false
    var userIsSeller = false
	var seguedFromMailbox = false
    var config = PayPalConfiguration()
	var timer: NSTimer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		messageTextView.delegate = self
		messageTableView.delegate = self
		messageTableView.dataSource = self
		//self.messageTableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
		
		// Do not autoscroll UITextViews within this view controller
		self.automaticallyAdjustsScrollViewInsets = false
		
		buyerHoldWarningLabel.hidden = true
		isNewNegotiation = false
		
		var bookTitle = ""
		if isNewListing {
			listing = Listing()
		}
		else {
			bookTitle = listing.book.title
		}

        var seller = listing.seller.fetchIfNeeded() as User
        userIsSeller = (seller.email == UserController.getCurrentUser().email)
        if(userIsSeller){
            purchaseButton.hidden = true
            holdButton.hidden = false
            soldButton.hidden = false
            if(listing.isOnHold){
                holdButton.setTitle("Remove Hold", forState: .Normal)
            } else {
                holdButton.setTitle("Hold", forState: .Normal)
            }
        }
		else {
            
            // show warning if on hold
			buyerHoldWarningLabel.hidden = !listing.isOnHold
            
            // hide purchase button if on hold
            if (listing.isOnHold || negotiation.purchaseRequested) {
                purchaseButton.hidden = true
            }
            
		}
		
		// Set navigation bar title
		self.title = bookTitle
		
		// Set message box boarder appearance
		self.messageTextView.layer.borderWidth = 2
		self.messageTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
		self.messageTextView.layer.cornerRadius = 8
		self.messageTextView.contentInset = UIEdgeInsetsMake(2.0, 1.0 , 0.0, 0.0)
		
		// If segued from Mailbox, the negotiation has been passed in. If not, query the database
		// for the negotiation.
		if !seguedFromMailbox {
			getListingNegotiation()
		}
        
        // Sets some handy sandbox defaults for PayPal
        config.forceDefaultsInSandbox = true
        config.sandboxUserPassword = "test1234"
        
        // TODO in production use currentUser for default email
        config.defaultUserEmail = "me-buyer@derekdowling.com"
        config.rememberUser = true
        config.merchantName = "TxtCrunch"
        config.merchantPrivacyPolicyURL = NSURL(string: "http://txtcrunch.com/privacy")
        config.merchantUserAgreementURL = NSURL(string: "http://txtcrunch.com/user-agreement")
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "updateNegotiationState:", userInfo: nil, repeats: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Callback for the UITextView that returns true if the text in the TextView should
	// be updated. Only allows the user to enter MAX_MESSAGE_LENGTH chars into the textbox
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		return countElements(messageTextView.text) + (countElements(text) - range.length) <= MAX_MESSAGE_LENGTH
	}
	
	// Check if negotiation with this seller and listingId exsts
	// If not, create a new negotiation
	func getListingNegotiation() {
		// Search for Negotiations who's buyer matches that of the current listing
		var resultNegotiation: Negotiation? = NegotiationDatabaseController.getListingNegotiation(listing, isSeller: self.userIsSeller)
		
		if (resultNegotiation != nil) {
			negotiation = resultNegotiation!
		}
	}
	
	// Sends a message between users when the send button is pressed
	@IBAction func onSendButtonClicked(sender: AnyObject) {
		if !messageTextView.text.isEmpty {
			var message = Message()
			message.sender = UserController.getCurrentUser()
		
			if (UserController.getCurrentUser() == negotiation.seller) {
				message.receiver = negotiation.buyer
				installation["selleruser"] = negotiation.seller
				installation["buyeruser"] = negotiation.buyer
				installation.saveInBackground()
			} else {
				message.receiver = negotiation.seller
				installation["buyeruser"] = negotiation.buyer
				installation["selleruser"] = negotiation.seller
				installation.saveInBackground()
			}
		
			message.content = messageTextView.text
			negotiation.messages.append(message)
			negotiation.save()
		
			// Clear the textview when message is sent.
			messageTextView.text = ""
			messageTableView.reloadData()
		}
	}
	
    // Called via timer, in a perfect world we could scrap (pieces of) this for
    // push notifications
	func updateNegotiationState(timer:NSTimer!) {
        
		var resultNegotiation: Negotiation? = NegotiationDatabaseController.getListingNegotiation(listing, isSeller: self.userIsSeller)
		
		if (resultNegotiation != nil) {
            // ask the seller if they'd like to sell if the buyer has offered
            if  (self.negotiation.purchaseRequested == false &&
                resultNegotiation?.purchaseRequested == true &&
                userIsSeller == true
            )
            {
                self.confirmSale()
                
            // if the seller confirms, pay up and complete from the user side
            // because we need their PayPal metadata
            } else if (
                self.negotiation.sellerConfirmation == false &&
                resultNegotiation?.sellerConfirmation == true &&
                userIsSeller == false
            ) {
                var paypalMetaDataID = PayPalMobile.clientMetadataID()
                if (PaymentManager.charge(self.negotiation, buyerMetaDataId: paypalMetaDataID))
                {
                    resultNegotiation?.completed = true
                    //resultNegotiation?.listing.isActive = false
                    resultNegotiation?.listing.save()
                    resultNegotiation?.save()
                }
                else {
                    // TODO error handling
                }
            }
            
            // update with newest negotiation, TODO: perhaps check if this is dirty
            // or something so we don't end up in a bizarre state
            self.negotiation = resultNegotiation!
            
            // TODO fix this, it's not being called
            if (self.negotiation.completed == true) {
                self.notifySuccess()
            }
		}
		
		messageTableView.reloadData()
		ListingDatabaseController.isListingOnHold(listing.objectId, callback: updateHoldWarningVisibility)
	}
	
	// Updates the UI element that informs the buyer if the Listing has 
	// been put on hold by the seller
	func updateHoldWarningVisibility(isOnHold: Bool) {
		if(!userIsSeller){
			buyerHoldWarningLabel.hidden = !isOnHold
		}
	}
	
	// Mandatory UITableViewDelete function
	// Returns number of rows in messagesTableView
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return negotiation.messages.count
	}
	
	// Mandatory UITableViewDelete function
	// Creates cell to be put into the listview
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: MessageTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as MessageTableViewCell

		cell.backgroundColor = UIColor.clearColor()
		cell.selectionStyle = UITableViewCellSelectionStyle.None
		
		// Do not allow user to interact with displayed message
		cell.receiverTextView.editable = false
		cell.receiverTextView.scrollEnabled = false
		
		var isSenderMessage: Bool = (negotiation.messages[indexPath.row].sender.objectId == UserController.getCurrentUser().objectId)
		cell.recipientImageView.hidden = isSenderMessage
		cell.senderImageView.hidden = !isSenderMessage
		
		if isSenderMessage {
			cell.receiverTextView.textAlignment = NSTextAlignment.Right
		} else {
			cell.receiverTextView.textAlignment = NSTextAlignment.Left
		}
		
		var content = negotiation.messages[indexPath.row].content
		cell.receiverTextView.text = content
		
		return cell
	}
	
	// Mandatory UITableViewDelete function
	// Populates cells with message data
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		let row = indexPath.row
		println(negotiation.messages[row].content)
	}
    
    @IBAction func toggleListingHold(sender: AnyObject) {
        if(listing.isOnHold){
            listing.isOnHold = false
            listing.save()
            holdButton.setTitle("Hold", forState: .Normal)
        } else if (!listing.isOnHold){
            listing.isOnHold = true
            listing.save()
            holdButton.setTitle("Remove Hold", forState: .Normal)
        }
        return
    }
    
    @IBAction func onSoldButtonClicked(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Mark as Sold", message: "Warning: Once you mark a listing as sold it will no longer show up in search results and this cannot be reversed. Continue?", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "I'm Sure", style: UIAlertActionStyle.Default, handler: {
            action in switch action.style{
            case .Default:
                self.listing.isActive = false
                self.listing.buyer = self.negotiation.buyer
                self.listing.save()
                self.performSegueWithIdentifier("soldButtonSegue", sender: nil)
                break
            default:
                break
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onPurchaseButtonClicked(sender: AnyObject) {
        var alert = UIAlertController(
            title: "Confirm Purchase",
            message: "Are you sure you'd like to purchase this textbook?",
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alert.addAction(UIAlertAction(
            title: "Continue",
            style: UIAlertActionStyle.Default,
            handler: {
            
            action in switch action.style {
                case .Default:
                    self.prepareBuyer()
                break
            default:
                break
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Called when the entire payment flow has completed successfully
    func notifySuccess() {
        var alert = UIAlertController(
            title: "Transaction Complete",
            message: "The Textbook was exchanged successfully",
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.Default,
            handler: {
                
                action in switch action.style {
                case .Default:
                    // TODO SEGUE HOME
                    break
                default:
                    break
                }
                
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func confirmSale() {
        
        var alert = UIAlertController(
            title: "Confirm Sale",
            message: "Are you sure you'd like to sell this textbook?",
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Default,
            handler: {
                action in switch action.style {
                case .Default:
                    self.negotiation.sellerConfirmation = true
                    self.negotiation.save()
                    // TODO pending message, spinner maybe
                    break
                default:
                    break
                }
                
        }))
        
        // TODO: need to reset state if the seller bails
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: {
                action in switch action.style {
                case .Cancel:
                    // if seller cancels, reset flow
                    self.negotiation.purchaseRequested = false
                    self.negotiation.save()
                    break
                default:
                    break
                }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Called when a buyer initiates textbook purchase. Checks PayPal
    // authorization and then prepares a charge
    func prepareBuyer() {
        
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
        
        var buyer: User? = negotiation.listing.buyer?.fetchIfNeeded() as? User
        
        if buyer?.buyerRefreshToken == nil {
        
            // call PayPals future payment OAuth Controller, result handler is
            // "payPalFuturePaymentViewController" function below
            let newPaymentInfoController = PayPalFuturePaymentViewController(configuration: config, delegate: self)
            presentViewController(newPaymentInfoController, animated: true, completion: nil)
        
        } else {
            // use existing PayPal info to prepare a payment
            self.doubleCheckBuyer()
        }
    }
    
    // Called when a buyer completes the Future Payment Flow
    func payPalFuturePaymentViewController(
        futurePaymentViewController: PayPalFuturePaymentViewController!,
        didAuthorizeFuturePayment response: [NSObject : AnyObject]!
        ) {
            
            // send authorizaiton to your server to get refresh token.
            futurePaymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                if (self.convertPaymentCodeToToken(response)) {
                    self.doubleCheckBuyer()
                } else {
                    // TODO: error
                }
                
            })
    }
    
    func doubleCheckBuyer() {
        var alert = UIAlertController(
            title: "Confirm Purchase",
            message: "Press Yes To Finalize",
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Default,
            handler: {
                
                action in switch action.style {
                case .Default:
                    self.negotiation.purchaseRequested = true
                    self.negotiation.save()
                    self.purchaseButton.hidden = true
                    break
                default:
                    break
                }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Handles making the appropriate calls to extract and save a the user's paypal info
    // for sellers
    func convertPaymentCodeToToken(response: [NSObject : AnyObject]!) -> Bool {
        
        var response = response["response"] as? [String: String]
        
        if response!["code"] != nil {
            
            var userEmail = User.currentUser().email
            var code = response?["code"]
            
            if code? != nil {
                return PaymentManager.saveCodeAsToken(userEmail, code: code!)
            }
        }
        
        // if we get to here something went wrong
        return false
    }
    
    // Called when a user cancels authorizing a payment
    func payPalFuturePaymentDidCancel(futurePaymentViewController: PayPalFuturePaymentViewController!) {
        println("PayPal Future Payment Authorizaiton Canceled")
        futurePaymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
	
	
	// Called when the current view appears
	override func viewDidAppear(animated: Bool) {
		// Instantiate the timer if the timer has been destroyed
		if timer == nil {
			timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "reloadNegotiationViewTable:", userInfo: nil, repeats: true)
		}
		
		// Ensure tableview starts at bottom (most recent messages)
		var indexPath = NSIndexPath(forRow: self.messageTableView.numberOfRowsInSection(0)-1, inSection: self.messageTableView.numberOfSections()-1)
		self.messageTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
	}
	
	// Called when the current view disappears
	override func viewDidDisappear(animated: Bool) {
		// Invalidate the timer when leaving the view
		if timer != nil {
			timer.invalidate()
			timer = nil
		}
	}
}
