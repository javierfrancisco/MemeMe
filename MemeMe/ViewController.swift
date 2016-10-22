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
        
         print("In viewDidLoad")
    
        prepareTextField(textField: topTextField, defaultText: "TOP")
        
        prepareTextField(textField: bottomTextField, defaultText:"BOTTOM")
    
        self.subscribeToKeyboardNotifications()
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("In viewWillAppear")
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        if(imagePickerView.image != nil){
            setTextFieldConstraints(image: imagePickerView.image!, view: imagePickerView )
            shareButton.isEnabled = true
        }else{
        
            shareButton.isEnabled = false
        }
          
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //unsubscribeFromKeyboardNotifications()
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    var topTextFieldConstraint: NSLayoutConstraint?
    var bottomTextFieldConstraint: NSLayoutConstraint?
    var textFieldYConstant: CGFloat = 0.0
  
    
    func setTextFieldConstraints(image: UIImage, view: UIView){
        

        if(!textFieldYConstant.isZero){
            //print("not zero")
            //disable previous contraints
            topTextFieldConstraint?.isActive = false
            bottomTextFieldConstraint?.isActive = false
    
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
            textFieldYConstant = textFieldYConstant - 60
            
            //print("newConstant: \(textFieldYConstant)")
            
            topTextFieldConstraint = imagePickerView.topAnchor.constraint(equalTo: topTextField.bottomAnchor , constant: textFieldYConstant)
            
            topTextFieldConstraint?.isActive = true
            
            bottomTextFieldConstraint = imagePickerView.bottomAnchor.constraint(equalTo: bottomTextField.topAnchor , constant: (textFieldYConstant * -1))
            
            bottomTextFieldConstraint?.isActive = true
     
        }

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            
            if(self.imagePickerView.image != nil){
                self.setTextFieldConstraints(image: self.imagePickerView.image!, view: self.imagePickerView )
                self.shareButton.isEnabled = true
            }else{
                
                self.shareButton.isEnabled = false
            }
            
        })
        
        
    }
    
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        //print("IN-->prepareTextField")
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ] as [String : Any]
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
        textField.delegate = memeTextFieldDelegate
        textField.text=defaultText
        
    }


    @IBAction func pickAnImage(sender: AnyObject) {
        
        
        print("In pickAnImageFromAlbum")
        
        pickAnImageFromSource(source: UIImagePickerControllerSourceType.photoLibrary);
        
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
   
        print("In pickAnImageFromCamera")
        
        pickAnImageFromSource(source: UIImagePickerControllerSourceType.camera);
        

    }
    
 
    @IBAction func shareMeme(sender: AnyObject) {
        
        print("In: shareTheMeme")
        
        let image = generateMemedImage()
        
        let nextController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        nextController.completionWithItemsHandler={
            
            (s: UIActivityType?, ok: Bool, items: [Any]?,err: Error?)  -> Void in
            
            if ok{
                self.save()
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
            
        self.present(nextController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func cancelOperation(){
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        shareButton.isEnabled = false
        
        topTextFieldConstraint?.isActive = false
        bottomTextFieldConstraint?.isActive = false
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolBar.isHidden = true
        navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame,
                                     afterScreenUpdates: true)
        memedImageFinal =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        toolBar.isHidden = false
        navigationBar.isHidden = false
        
        return memedImageFinal
        
    }

    
    
    func pickAnImageFromSource( source: UIImagePickerControllerSourceType){
        
        print("In pickAnImageFromSource")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("In Cancel action")
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    
        //print("In Image was selected ")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //print("an image exists ")
            imagePickerView.image = image
            imagePickerView.contentMode=UIViewContentMode.scaleAspectFit
            
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func subscribeToKeyboardNotifications() {
        
        print("IN-->subscribeToKeyboardNotifications")
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:))   , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    var keyboardHeight : CGFloat = 0.0
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("IN-->keyboardWillShow")
        
        if(memeTextFieldDelegate.currentEditingTextField==2){
            
            keyboardHeight=getKeyboardHeight(notification: notification)

            view.frame.origin.y =  getKeyboardHeight(notification: notification) * -1
        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
       // print("IN-->keyboardWillHide")
        
        if(memeTextFieldDelegate.currentEditingTextField==2){
            
            self.view.frame.origin.y += keyboardHeight

        }
        
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        //print("IN-->getKeyboardHeight")
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        //print("IN-->getKeyboardHeight2: \( keyboardSize.cgRectValue.height)")
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        //Create the meme
        let meme = Meme( topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, image:
            imagePickerView.image!,
                  memedImage: memedImageFinal)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    
    
    
}

