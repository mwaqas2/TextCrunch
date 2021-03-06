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
    
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var soldButton: UIButton!
	@IBOutlet weak var buyerHoldWarningLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
	let cellIdentifier = "NegotiationMessageCell"
	let MAX_MESSAGE_LENGTH = 140
	
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
		
		// Do not autoscroll UITextViews within this view controller
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pentagon.png")!)
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
        
        // setup state buttons based on buyer/seller
        if (self.negotiation.completed) {
            
            // if completed, basically just disable everything, and put this
            // screen into read-only mode
            self.purchaseButton.hidden = true
            self.holdButton.hidden = true
            self.soldButton.hidden = true
            self.sendButton.hidden = true
            self.messageTextView.hidden = true
            
        }
        else if(self.userIsSeller) {
            
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
            if (listing.isOnHold || self.negotiation.purchaseRequested) {
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
        
        // setup push notification queryables
        installation["buyeruser"] = self.negotiation.buyer
        installation["selleruser"] = self.negotiation.seller
        installation.saveInBackground()
        
        // Sets some handy sandbox defaults for PayPal
        config.forceDefaultsInSandbox = true
        config.sandboxUserPassword = "test1234"
        
        // TODO in production use currentUser for default email
        config.defaultUserEmail = "me-buyer@derekdowling.com"
        config.rememberUser = true
        config.merchantName = "TxtCrunch"
        config.merchantPrivacyPolicyURL = NSURL(string: "http://txtcrunch.com/privacy")
        config.merchantUserAgreementURL = NSURL(string: "http://txtcrunch.com/user-agreement")
        
        updateNewMessageFlags()

        // DO THIS ALL LAST SO WE DON'T START ANYTHING BEFORE THE CONFIG IS ALL SETUP
        if (self.userIsSeller && self.negotiation.purchaseRequested && !self.negotiation.completed) {
            self.confirmSale()
        }
        
        // only turn on our update logic if the negotiation hasn't already been
        // completed
        if !self.negotiation.completed {
            timer = NSTimer.scheduledTimerWithTimeInterval(
                3,
                target: self,
                selector: "updateNegotiationState:",
                userInfo: nil,
                repeats: true
            )
        }
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
        var resultNegotiation: Negotiation? = nil
        
        if self.userIsSeller {
            resultNegotiation = NegotiationDatabaseController.getListingNegotiation(listing, isSeller: self.userIsSeller, buyer: negotiation.buyer, seller: negotiation.seller)
        } else {
            resultNegotiation = NegotiationDatabaseController.getListingNegotiation(listing, isSeller: self.userIsSeller, buyer: UserController.getCurrentUser(), seller: listing.seller as User)
        }
		
		if (resultNegotiation != nil) {
			self.negotiation = resultNegotiation!
		}
	}
	
	// Sends a message between users when the send button is pressed
	@IBAction func onSendButtonClicked(sender: AnyObject) {
		
        if !messageTextView.text.isEmpty {
		
            var receiver: User
            
            if self.userIsSeller {
                receiver = self.negotiation.buyer
            } else {
                receiver = self.negotiation.seller
            }
            
            self.negotiation.sendMessage(messageTextView.text, receiever: receiver, receiverIsSeller: self.userIsSeller)
		
			// Clear the textview when message is sent.
			self.messageTextView.text = ""
			self.messageTableView.reloadData()
		}
        
	}
	
    // Called via timer, in a perfect world we could scrap (pieces of) this for
    // push notifications
	func updateNegotiationState(timer:NSTimer!) {
        
        // Search for Negotiations who's buyer matches that of the current listing
        var resultNegotiation: Negotiation? = nil
        
        if self.userIsSeller {
            resultNegotiation = NegotiationDatabaseController.getListingNegotiation(listing, isSeller: self.userIsSeller, buyer: negotiation.buyer, seller: negotiation.seller)
        } else {
            resultNegotiation = NegotiationDatabaseController.getListingNegotiation(listing, isSeller: self.userIsSeller, buyer: UserController.getCurrentUser(), seller: listing.seller as User)
        }
		
		if (resultNegotiation != nil) {
            // ask the seller if they'd like to sell if the buyer has offered
            if (self.negotiation.purchaseRequested == false &&
                resultNegotiation?.purchaseRequested == true &&
                userIsSeller == true
            ) {
                self.confirmSale()
            }
            
            if (!self.userIsSeller &&
                self.negotiation.purchaseRequested &&
                resultNegotiation?.purchaseRequested == false
            ) {
                self.paymentNotification("Seller rejected purchase request.")
            }
            
            // update with newest negotiation, TODO: perhaps check if this is dirty
            // or something so we don't end up in a bizarre state
            self.negotiation = resultNegotiation!
            
            // Show a success notification if either party is in the negotiation
            // screen when everything is finalized
            if (resultNegotiation?.completed == true &&
                self.negotiation.completed == false
            ) {
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
		return self.negotiation.messages.count
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
		
		var isSenderMessage: Bool = (self.negotiation.messages[indexPath.row].sender.objectId == UserController.getCurrentUser().objectId)
		cell.recipientImageView.hidden = isSenderMessage
		cell.senderImageView.hidden = !isSenderMessage
		
		if isSenderMessage {
			cell.receiverTextView.textAlignment = NSTextAlignment.Right
		} else {
			cell.receiverTextView.textAlignment = NSTextAlignment.Left
		}
		
		var content = self.negotiation.messages[indexPath.row].content
		cell.receiverTextView.text = content
		cell.receiverTextView.sizeToFit()
		return cell
	}
	
	// Mandatory UITableViewDelete function
	// Populates cells with message data
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		let row = indexPath.row
		println(self.negotiation.messages[row].content)
	}
	
	// Sets the cell height for each message cell in the tableview
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		var cell: MessageTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as MessageTableViewCell
		var content = self.negotiation.messages[indexPath.row].content
		
		// Calculate the height required to contain the message text
		cell.receiverTextView.text = content
		cell.receiverTextView.sizeToFit()
		return cell.receiverTextView.frame.size.height + 20.0
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
    
    // Handler when Buyer attempts to purchase a book
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
            message: "The Textbook was exchanged successfully!",
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.Default,
            handler: {
                
                action in switch action.style {
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
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Called for the seller after the buyer has initiated the payment process
    // after the seller confirms, the buyer will double check before paying
    func confirmSale() {
        
        var alert = UIAlertController(
            title: "Confirm Sale",
            message: "The buyer would like to buy your book. Would you like to continue?",
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alert.addAction(UIAlertAction(
            title: "Sell",
            style: UIAlertActionStyle.Default,
            handler: {
                action in switch action.style {
                case .Default:

                    if (PaymentManager.capturePayment(self.negotiation)) {
                        self.notifySuccess()
                        self.negotiation.sendMessage("Purchase Approved By Seller", receiever: self.negotiation.buyer, receiverIsSeller: false)
                    } else {
                        self.negotiation.purchaseRequested = false
                        self.negotiation.paymentCaptureUrl = ""
                        self.negotiation.save()
                        self.paymentNotification("Error completing payment. Buyer must initiate again.")
                    }
                    
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
                    self.negotiation.paymentCaptureUrl = ""
                    self.negotiation.save()
                    break
                default:
                    break
                }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Called when a buyer initiates textbook purchase. Checks PayPal
    // authorization and then prepares a prepareCharge
    func prepareBuyer() {
        
        // Make sure that we're persisting a new negotiation before any payment
        // stuff goes down
        if self.negotiation.isDirty() {
            self.negotiation.save()
        }
        
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
                    self.paymentNotification("Error approving PayPal account. Try again.")
                }
                
            })
    }
    
    // presents one final buyer alert confirmation before setting up the PayPal
    // Payment that the seller can confirm
    func doubleCheckBuyer() {
        
        var alert = UIAlertController(
            title: "Confirm Purchase",
            message: "Are you sure you'd like to proceeed?",
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alert.addAction(UIAlertAction(
            title: "Purchase",
            style: UIAlertActionStyle.Default,
            handler: {
                
                action in switch action.style {
                case .Default:
                    
                    var paypalMetaDataID = PayPalMobile.clientMetadataID()
                    if (PaymentManager.prepareCharge(self.negotiation, buyerMetaDataId: paypalMetaDataID))
                    {
                        self.negotiation.purchaseRequested = true
                        self.negotiation.save()
                        self.purchaseButton.hidden = true
                        
                        self.negotiation.sendMessage("Buyer Purchase Requested", receiever: self.negotiation.seller, receiverIsSeller: true)
                        self.paymentNotification("Waiting on seller purchase confirmation.")
                        
                    } else {
                        self.paymentNotification("Error approving purchase. Please try again.")
                    }
                    
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
        
        futurePaymentViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
	
	// Update the negotiation's new messages flags
	func updateNewMessageFlags() {
		// Only update the new message flags if the current negotiation has saved messages
		if (self.negotiation.messages.count > 0) {
			// Update the flags to indicate that the current user has seen the latest messages
			if self.userIsSeller {
				self.negotiation.isNewBuyerMessage = false
			} else {
				self.negotiation.isNewSellerMessage = false
			}

			self.negotiation.save()
		}
	}
	
	
	// Called when the current view appears
	override func viewDidAppear(animated: Bool) {
		// Instantiate the timer if the timer has been destroyed
		if timer == nil {
			timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "updateNegotiationState:", userInfo: nil, repeats: true)
		}
		
		updateNewMessageFlags()
		
		// Ensure tableview starts at bottom (most recent messages)
		if (self.negotiation.messages.count > 0) {
			var indexPath = NSIndexPath(forRow: self.messageTableView.numberOfRowsInSection(0)-1, inSection: self.messageTableView.numberOfSections()-1)
			self.messageTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
		}
	}
	
	// Called when the current view disappears
	override func viewDidDisappear(animated: Bool) {
		// Invalidate the timer when leaving the view
		if timer != nil {
			timer.invalidate()
			timer = nil
		}
		
		updateNewMessageFlags()
	}
    
    // Use to display various payment notifications that don't require complex
    // handling
    func paymentNotification(message: String) {

        var alert = UIAlertController(
            title: "Payment Notification",
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        );
        
        alert.addAction(UIAlertAction(
            title: "Okay",
            style: UIAlertActionStyle.Default,
            handler: nil
        ))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
