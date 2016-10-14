//
//  ViewController.swift
//  MemeMe
//
//  Created by zenkiu on 9/14/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    var memedImageFinal : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        prepareTextField(topTextField, defaultText: "TOP")
        
        prepareTextField(bottomTextField, defaultText:"BOTTOM")
    
        self.subscribeToKeyboardNotifications()
    }

    
    
    override func viewWillAppear(animated: Bool) {
        
        print("In viewWillAppear")
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        if(imagePickerView.image != nil){
            setTextFieldConstraints(imagePickerView.image!, view: imagePickerView )
            shareButton.enabled = true
        }else{
        
            shareButton.enabled = false
        }
          
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //unsubscribeFromKeyboardNotifications()
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    var topTextFieldConstraint: NSLayoutConstraint?
    var bottomTextFieldConstraint: NSLayoutConstraint?
    var textFieldYConstant: CGFloat = 0.0
  
    
    func setTextFieldConstraints(image: UIImage, view: UIView){
        

        if(!textFieldYConstant.isZero){
            print("not zero")
            //disable previous contraints
            topTextFieldConstraint?.active = false
            bottomTextFieldConstraint?.active = false
    
        }
        
        
        let scaleFactorWidth = view.frame.size.width / image.size.width
        
        let scaleFactorHeight = view.frame.size.height / image.size.height
        
        var minScaleFactor : CGFloat
        if(scaleFactorWidth < scaleFactorHeight){
            minScaleFactor = scaleFactorWidth
        }else{
            minScaleFactor = scaleFactorHeight
        }
        

        if( minScaleFactor < 1 ){
            
            
            let newImageHeight = image.size.height * minScaleFactor

            textFieldYConstant = ( ( (view.frame.size.height - newImageHeight) / 2 ) * -1 )
            textFieldYConstant = textFieldYConstant - 40
            
            print("newConstant: \(textFieldYConstant)")
            
            topTextFieldConstraint = imagePickerView.topAnchor.constraintEqualToAnchor(topTextField.bottomAnchor , constant: textFieldYConstant)
            
            topTextFieldConstraint?.active = true
            
            bottomTextFieldConstraint = imagePickerView.bottomAnchor.constraintEqualToAnchor(bottomTextField.topAnchor , constant: (textFieldYConstant * -1))
            
            bottomTextFieldConstraint?.active = true
     
        }

    }
    
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        print("IN-->prepareTextField")
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
        textField.delegate = memeTextFieldDelegate
        textField.text=defaultText
        
    }


    @IBAction func pickAnImage(sender: AnyObject) {
        
        
        print("In pickAnImageFromAlbum")
        
        pickAnImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary);
        
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
   
        print("In pickAnImageFromCamera")
        
        pickAnImageFromSource(UIImagePickerControllerSourceType.Camera);
        

    }
    
 
    @IBAction func shareMeme(sender: AnyObject) {
        
        print("In: shareTheMeme")
        
        let image = generateMemedImage()
        
        let nextController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        nextController.completionWithItemsHandler={
            
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            
            if ok{
                self.save()
            }
            
        }
        
        self.presentViewController(nextController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        cancelOperation()
    }
    
    func cancelOperation(){
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        shareButton.enabled = false
        
        topTextFieldConstraint?.active = false
        bottomTextFieldConstraint?.active = false
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolBar.hidden = true
        navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
                                     afterScreenUpdates: true)
        memedImageFinal =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        toolBar.hidden = false
        navigationBar.hidden = false
        
        return memedImageFinal
        
    }

    
    
    func pickAnImageFromSource( source: UIImagePickerControllerSourceType){
        
        print("In pickAnImageFromSource")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("In Cancel action")
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print("In Image was selected ")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("an image exists ")
            imagePickerView.image = image
            imagePickerView.contentMode=UIViewContentMode.ScaleAspectFit
            
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        
        print("IN-->subscribeToKeyboardNotifications")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    var keyboardHeight : CGFloat = 0.0
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("IN-->keyboardWillShow")
        
        if(memeTextFieldDelegate.currentEditingTextField==2){
            
            keyboardHeight=getKeyboardHeight(notification)

            view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        print("IN-->keyboardWillHide")
        
        if(memeTextFieldDelegate.currentEditingTextField==2){
            
            self.view.frame.origin.y += keyboardHeight

        }
        
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        print("IN-->getKeyboardHeight")
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        print("IN-->getKeyboardHeight2: \( keyboardSize.CGRectValue().height)")
        return keyboardSize.CGRectValue().height
    }
    
    func save() {
        //Create the meme
        _ = Meme( topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, image:
            imagePickerView.image!,
                  memedImage: memedImageFinal)
    }
    
    
}

