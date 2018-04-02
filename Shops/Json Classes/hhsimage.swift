//
//  hhsimage.swift
//  collection
//
//  Created by Admin on 11/18/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit

@IBDesignable
open class hhsimage: UIImageView {
    
    @IBInspectable dynamic open var cornerradius : CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerradius
            self.layer.masksToBounds = true
        }
    }
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
