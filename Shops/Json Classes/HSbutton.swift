//
//  HSbutton.swift
//  mycustomuikit
//
//  Created by Admin on 12/2/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit
@IBDesignable class HSbutton: UIButton {
    @IBInspectable dynamic open var circlebutton: Bool = false {
    didSet {
        setup()
        }
    }
    
    @IBInspectable dynamic open var borderwidth: CGFloat = 0.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable dynamic open var bordercolor : UIColor = .clear {
        didSet {
            setup()
        }
    }
    
    @IBInspectable dynamic open var cornerradius : CGFloat = 0.0 {
        didSet {
            setup()
        }
    }
    
    override func draw(_ rect: CGRect) {
        setup()
    }
    
    func setup(){
        if circlebutton {
            
      layer.cornerRadius = frame.height / 2
        }
            
     else
        {
       layer.cornerRadius = cornerradius
        }
        layer.masksToBounds = true
        layer.borderWidth = borderwidth
        layer.borderColor = bordercolor.cgColor
    }
}
