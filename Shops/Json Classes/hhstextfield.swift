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
open class hhstextfield: UITextField {
    
    open var noemptybool : Bool = false
    open var emailtruebool: Bool = false
    open var overlaybutton : UIButton =  UIButton.init(type: .custom)
    
    @IBInspectable dynamic open var iscategorybool: Bool = false
    @IBInspectable dynamic open var width: CGFloat = 30
    @IBInspectable dynamic open var height: CGFloat = 30
    @IBInspectable dynamic open var buttonmarginright: CGFloat = 5
    
    @IBInspectable dynamic open var bordercolor: UIColor = UIColor.clear {
        didSet {
           layer.borderColor = bordercolor.cgColor
            layer.borderWidth = 1
        }
    }
    @IBInspectable dynamic open var radius: CGFloat = 0.0{
        didSet {
            layer.cornerRadius = radius
            layer.masksToBounds = true
        }
    }
    @IBInspectable dynamic open var imgg: UIColor = UIColor.clear {
        didSet {
            setup()
        }
    }
    
    //    @IBInspectable dynamic open var leftimage: UIImage? {
    //        didSet {
    //        let overlayleftimage : UIImageView = UIImageView.init(image: leftimage)
    //        leftView = overlayleftimage
    //        leftViewMode = UITextFieldViewMode.always
    //    }
    //     }
    @IBInspectable open var imag: UIImage? {
        didSet{
            setup()
        }
    }
    
    
    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return  CGRect.init(x: frame.width - width - buttonmarginright , y: (frame.height - height) / 2 , width: width , height: height)
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        
    }
    fileprivate func setup(){
        
        overlaybutton.backgroundColor = imgg
        overlaybutton.setImage(imag, for: .normal)
        rightView = overlaybutton
        rightViewMode = UITextFieldViewMode.always
        
    }
    open func checknoempty() {
        if (self.text?.isEmpty)! || (self.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            if iscategorybool {
                imag = #imageLiteral(resourceName: "getcategoryred")
                iscategorybool = false
            }
            else
            {
                imag = #imageLiteral(resourceName: "falsered")
                
            }
            noemptybool = false
        }
        else
        {
            if iscategorybool {
                imag = #imageLiteral(resourceName: "getcategorygreen")
                iscategorybool = false
            }
            else {
                imag = nil
            }
            noemptybool = true
        }
    }
    open func checkemail()
    {
        emailtruebool = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self.text! as NSString
            let results = regex.matches(in: self.text!, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                emailtruebool = false
                imag = #imageLiteral(resourceName: "falsered")
            }
            else {
                emailtruebool = true
                imag = #imageLiteral(resourceName: "truegreen")
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            emailtruebool = false
            imag = #imageLiteral(resourceName: "falsered")
        }
        
    }
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    open  func validate() -> Bool {
        let PHONE_REGEX = "^[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self.text)
        if result {
            imag = #imageLiteral(resourceName: "truegreen")
            noemptybool = true
        }
        else {
            imag = #imageLiteral(resourceName: "falsered")
            noemptybool = false
        }
        return result
    }
}

