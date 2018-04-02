//
//  Cardview.swift
//  collection
//
//  Created by Admin on 11/12/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
open class HScardview: UIView {
    
    
    @IBInspectable dynamic open var mycornerradius : CGFloat = 12 {
        didSet {
            configure()
        }
    }
    
    @IBInspectable dynamic open var myshadowcolor : UIColor = UIColor.black {
        didSet {
            
            configure()
            
        }
    }
    
    @IBInspectable dynamic open var myshadowopacity: Float = 0.8 {
        didSet {
            configure()
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        
    }
    fileprivate func configure() {
        
        layer.cornerRadius = mycornerradius
        layer.masksToBounds = false
        layer.shadowColor = myshadowcolor.withAlphaComponent(0.2).cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: 0)
        layer.shadowOpacity = myshadowopacity
        self.setNeedsDisplay()
        
    }
    
}



