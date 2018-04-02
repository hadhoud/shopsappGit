//
//  customtext.swift
//  collection
//
//  Created by Admin on 11/13/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit
import QuartzCore
@IBDesignable
open class hhstextview: UITextView   {
    
  
    @IBInspectable dynamic open var placeholder: String = ""
        {
        didSet {
            setup()
        }
    }
   
    
    
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        
    }
    fileprivate func setup(){
        self.delegate = self
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
       self.text = placeholder
        self.textColor = UIColor.lightGray
    }
    
    open func gettext() -> String {
        if   self.text == placeholder {
        return ""
        }
        else {
            return self.text
        }
        
    }
    open func showtext(text:String) {
        if  text == "" {
           self.text = placeholder
            self.textColor = UIColor.lightGray
        }
        else {
           self.text = text
         self.textColor = UIColor.black
        }
        
    }
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
extension hhstextview: UITextViewDelegate {
 
    public func textViewDidChange(_ textView: UITextView) {
        if self.textColor == UIColor.lightGray {
            self.text = nil
            self.textColor = UIColor.black
        }
        else  if  (self.text.isEmpty) || (self.text.trimmingCharacters(in: .whitespaces).isEmpty) {
            
            self.text = placeholder
            self.textColor = UIColor.lightGray
        }
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textColor == UIColor.lightGray {
            self.text = nil
            self.textColor = UIColor.black
        }
    }
      public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if  (self.text.isEmpty) || (self.text.trimmingCharacters(in: .whitespaces).isEmpty) {
        
            self.text = placeholder
            self.textColor = UIColor.lightGray
        }
    }
}


