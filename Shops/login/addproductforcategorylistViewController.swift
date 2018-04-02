//
//  addproductforcategorylistViewController.swift
//  Shops
//
//  Created by Admin on 12/1/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit

class addproductforcategorylistViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate  {
    
    @IBOutlet weak var descriptiontext: hhstextview!
    @IBOutlet weak var pricetext: hhstextfield!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var titletext: hhstextfield!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var savebarbutton: UIBarButtonItem!
    
    // variable
    var editstep: Bool = false
    var myaddproducts : products?
    var imagechanged: Bool = false
    var data : [String : Any] = [ "row" : -1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titletext.delegate = self
        self.pricetext.delegate = self
        
        
        addobservers()
        
        if editstep {
            imagechanged = true
            filldata()
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addobservers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeobservers()
    }
    
    // fill data for editing step
    func filldata(){
        self.savebarbutton.title = "Done"
        self.navigationController?.title = "Edit Product"
        self.titletext.text = myaddproducts?.title
 
        self.logo.getlogofrombytearray(byteint8: myaddproducts?.logo ?? [])
        self.pricetext.text = "\(myaddproducts?.price ?? 0)"
        self.descriptiontext.text = myaddproducts?.description
        
    }
    
    // save button click
    @IBAction func addproductsaveclicked(_ sender: UIBarButtonItem) {
        let load = MBProgressHUD.showAdded(to: self.view, animated: true)
        load.mode = .indeterminate
        load.label.text = "loading"
        self.view.isUserInteractionEnabled = false
        load.show(animated: true)
        self.titletext.checknoempty()
        self.pricetext.checknoempty()
       
        if imagechanged {
            if  titletext.noemptybool &&  pricetext.noemptybool && imagechanged {
                
                myaddproducts = products.init(title: self.titletext.text!, logo: base_api().toarrayofbyte(image: self.logo.image ?? #imageLiteral(resourceName: "noImage")), description: self.descriptiontext.gettext() , price: Int(self.pricetext.text ?? "0") ?? 0)
                
            load.hide(animated: true)
            self.view.isUserInteractionEnabled = true
            // perform unwind segue from addproduct
            performSegue(withIdentifier: "backtocategoryproductlist", sender: self)
            }
            self.showToast(message: "Fill all The Fields")
            load.hide(animated: true)
            self.view.isUserInteractionEnabled = true
        }
        else
            {
          
       
        load.hide(animated: true)
        self.view.isUserInteractionEnabled = true
        self.showToast(message: "Choose A Logo")
        }
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is addcategoryController {
            if let toaddcategory = segue.destination as? addcategoryController {
                toaddcategory.productfromadd = myaddproducts!
            }
        }
    }
    
    @IBAction func addproductlogoclicked(_ sender: UITapGestureRecognizer) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.logo.image = image
            imagechanged = true
        }
        self.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // touch view to hide keyboard
    @IBAction func viewclickedforkeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    //add observers for keyboard
    fileprivate func addobservers(){
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: {notification in self.keyboardshow(notification: notification)})
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: {notification in self.keyboardhide(notification: notification)})
    }
    
    // remove observers
    func removeobservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //hide keyboard
    func keyboardhide(notification: Notification){
        scrollview.contentInset = UIEdgeInsets.zero
    }
    
    //show keyboard scrolling
    func keyboardshow(notification: Notification){
        guard let userinfo = notification.userInfo , let frame = (userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentinset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height - 20 , right: 0)
        scrollview.contentInset = contentinset
    }
    
    //***************************************************************
    

}
