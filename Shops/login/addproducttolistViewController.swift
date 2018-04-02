//
//  addP2CViewController.swift
//  Shops
//
//  Created by Admin on 11/29/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit


    class addproducttolistViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate , UITextViewDelegate {
        
        @IBOutlet weak var savebutton: UIButton!
        @IBOutlet weak var addproductdescription: hhstextview!
        @IBOutlet weak var addproductpricetext: hhstextfield!
        @IBOutlet weak var addproductlogo: UIImageView!
        
        @IBOutlet weak var addproducttitletext: hhstextfield!
        @IBOutlet weak var scrollview: UIScrollView!
        
        var editstep: Bool = false
        var data : [String : Any] = [ "row" : -1]
        
      //  var add_category : categories?
        var myaddproducts : products?
        var imagechanged: Bool = false
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.addproductpricetext.delegate = self
            self.addproducttitletext.delegate = self
          //  self.addproductcategorytext.delegate = self
            self.addproductdescription.delegate = self
           
        }
        
       
       
        
        
        
      
        
        
       
        
     
        
        
       
       
        
       
}


