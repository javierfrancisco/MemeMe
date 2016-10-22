//
//  MemeTextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by zenkiu on 8/7/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation
import UIKit


class MemeTextFieldDelegate: NSObject,  UITextFieldDelegate, UINavigationControllerDelegate {
    
    var currentEditingTextField=0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //print("In: textFieldDidBeginEditing")
        
        
        if textField.text == "BOTTOM"{
            
            textField.text = ""
        }
        
        if textField.text == "TOP"{
            
            textField.text = ""
        }
        
        currentEditingTextField=textField.tag
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        //print("In: textFieldShouldReturn")
        
        return true;
    }
    
}
