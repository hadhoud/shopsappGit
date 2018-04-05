//
//  addproductproviderViewController.swift
//  collection
//
//  Created by Admin on 15/11/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit

class addproductproviderViewController: UIViewController , UITextFieldDelegate , UINavigationControllerDelegate , UIImagePickerControllerDelegate   {
    
    @IBOutlet weak var categorytext: hhstextfield!
    @IBOutlet weak var producttitle: hhstextfield!
    @IBOutlet weak var productprice: hhstextfield!
    @IBOutlet weak var productlogo: hhsimage!
    @IBOutlet weak var productdescription: hhstextview!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var morerightitem: UIBarButtonItem!
    
    var editaddstep: Bool = false
    var actionsheet: UIAlertController!
    var editactionsheet: UIAlertController!
    var load = MBProgressHUD()
    var showproductbool: Bool = false
    var editproductbool: Bool = false
    var havechange: Bool = false
    var productoshow : product?
    var categoryname: String = ""
    var token: String = ""
    var imagechanged: Bool = false
    var yoftext: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.contentInset = UIEdgeInsets.zero
        print(token)
        categorytext.delegate = self
        producttitle.delegate = self
        productprice.delegate = self
        addobservers()
        setupactionsheet()
        setupeditactionsheet()
        setupview()
        
    }
    
    @objc func moreclicked()
    {
        if showproductbool {
            if editproductbool
            {
                self.present(editactionsheet, animated: true, completion: nil)
            }
            else
            {
                self.present(actionsheet, animated: true, completion: nil)
            }
            
        }
        else
        {
            saveproduct()
        }
        
        
    }
    
    @IBAction func backleftbaritemclicke(_ sender: Any)
    {
        if showproductbool && !editproductbool
        {
            self.performSegue(withIdentifier: "backtoprovidershopfromaddproduct", sender: self)
        }
            
        else
        {
            let exitalert = UIAlertController.init(title: "Warning", message: "Do you Want Save Before Exit", preferredStyle: .alert)
            
            let yes = UIAlertAction.init(title: "Yes", style: .default, handler: { action in
                self.saveproduct()
            })
            
            let no = UIAlertAction.init(title: "No", style: .default, handler: { action in
                self.performSegue(withIdentifier: "backtoprovidershopfromaddproduct", sender: self)
            })
            
            exitalert.addAction(yes)
            exitalert.addAction(no)
            
            self.present(exitalert, animated: true, completion: nil)
        }
    }
    
    func setupeditactionsheet(){
        editactionsheet = UIAlertController.init(title: nil , message: nil , preferredStyle: .actionSheet)
        let editcancel = UIAlertAction.init(title: "Cancel Edit", style: .default, handler: { action in self.edit() })
        let editsave = UIAlertAction.init(title: "Save Product", style: .destructive, handler: { action in self.saveproduct()})
        let close = UIAlertAction.init(title: "Close", style: .default, handler: nil)
        
        editactionsheet.addAction(editcancel)
        editactionsheet.addAction(editsave)
        editactionsheet.addAction(close)
    }
    
    func setupactionsheet(){
        actionsheet = UIAlertController.init(title: nil, message:nil, preferredStyle: .actionSheet)
        
        let edit = UIAlertAction.init(title: "Edit Product", style: .default, handler: { action in self.edit() })
        
        let delete = UIAlertAction.init(title: "Delete Product", style: .destructive, handler: { action in self.deletemyproduct() })
        
        let close = UIAlertAction.init(title: "Close", style: .default, handler: nil)
        
        actionsheet.addAction(edit)
        actionsheet.addAction(delete)
        actionsheet.addAction(close)
    }
    @objc func categoryclicked(){
        performSegue(withIdentifier: "tocategorytablefromaddproductprovider", sender: self)
    }
    func setupview()
    {
        self.categorytext.overlaybutton.addTarget(self, action: #selector(self.categoryclicked), for: .touchUpInside)
        if showproductbool
        {
            disabletext()
            showproduct()
            let more = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(self.moreclicked))
            self.navigationItem.setRightBarButton(more, animated: true)
        }
        else
        {
            let more = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(self.moreclicked))
            self.navigationItem.setRightBarButton(more, animated: true)
        }
    }
    
    func saveproduct(){
        producttitle.checknoempty()
        productprice.checknoempty()
        categorytext.iscategorybool = true
        categorytext.checknoempty()
        if  imagechanged
        {
            if producttitle.noemptybool && productprice.noemptybool && categorytext.noemptybool
            {
                var id = ""
                if showproductbool {
                    id = "\(self.productoshow?.id ?? 0 )"
                }
                self.loading_show()
                saveproductjson(image: self.productlogo.image!, auth_token: token, product_id: id , title: self.producttitle.text!, description: self.productdescription.gettext(), price: Int(self.productprice.text!) ?? 0, category_name: self.categorytext.text!)
                
            }
            else
            {
                self.showToast(message: "Fill all the fields")
            }
        }
        else
        {
            self.showToast(message: "Choose a Logo")
        }
    }
    
    
    func edit()
    {
        if editproductbool {
            // in cancel edit
            showproduct()
            editproductbool = false
            disabletext()
            
        }
        else {
            // in edit step
            enabletext()
            imagechanged = true
            editproductbool = true
            self.productprice.text = String(self.productoshow!.price ?? "0")
        }
    }
    
    func deletemyproduct(){
        let deletealert = UIAlertController.init(title: "Warning", message: "Are you Sure you Want Delete Product", preferredStyle: .alert)
        
        let yes = UIAlertAction.init(title: "Yes", style: .default, handler: { action in
            self.loading_show()
            let id = ("\(self.productoshow!.id ?? 0)")
            self.delete_product(auth_token: self.token, product_id: id)
            
        })
        
        let no = UIAlertAction.init(title: "No", style: .default, handler: nil)
        
        deletealert.addAction(yes)
        deletealert.addAction(no)
        
        self.present(deletealert, animated: true, completion: nil)
        
    }
    func disabletext(){
        
        self.categorytext.isEnabled = false
        self.producttitle.isEnabled = false
        self.productprice.isEnabled = false
        self.productdescription.isEditable = false
        
        
    }
    
    func enabletext(){
        self.categorytext.becomeFirstResponder()
        self.categorytext.isEnabled = true
        self.producttitle.isEnabled = true
        self.productprice.isEnabled = true
        self.productdescription.isEditable = true
    }
    
    func showproduct()
    {
        
        self.productlogo.getlogofromurl(productoshow!.logo ?? "")
        self.categorytext.text = self.categoryname
        self.producttitle.text = self.productoshow!.title ?? ""
        self.productprice.text = ("\(self.productoshow!.price ?? "0" ) $")
        self.productdescription.showtext(text: self.productoshow!.description ?? "")
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        // back to shopproviderinfo
        case "backtoprovidershopfromaddproduct":
            if let providershop = segue.destination as? ProvidershopinfoViewController {
                if havechange {
                    
                    providershop.needrefresh = true
                    
                }
                else
                {
                    providershop.needrefresh = false
                }
            }
        // to category table
        case "tocategorytablefromaddproductprovider" :
            if let categorytable = segue.destination as? CategoryTableViewController {
                categorytable.fromsearchbool = "addprovider"
            }
            
        default:
            break
        }
        
        
    }
    
    // unwind segue
    @IBAction func addproductproviderunwind(unwindSegue: UIStoryboardSegue)
    {
        if let fromcategory = unwindSegue.source as? CategoryTableViewController {
            self.categorytext.text = fromcategory.categorychoosed
        }
    }
    
    
    
    // add logo picker
    @IBAction func addproductproviderlogoclicked(_ sender: UITapGestureRecognizer) {
        if !showproductbool || editproductbool {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            image.allowsEditing = true
            self.present(image, animated: true, completion: nil)}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.productlogo.image = image
            imagechanged = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    // keyboard and scroll
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeobservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addobservers()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func viewclickedforkeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    //add observers for keyboard
    fileprivate func addobservers(){
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: {notification in self.keyboardshow(notification: notification)})
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: {notification in self.keyboardhide(notification: notification)})
        scrollview.contentInset = UIEdgeInsets.zero
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
    
    //// ********* save product *******
    
    func saveproductjson(image : UIImage ,auth_token : String , product_id : String ,  title : String , description : String , price : Int , category_name : String)  {
        
        let arraybyte = base_api().toarrayofbyte(image: image)
        let productto = product_save(auth_token: auth_token , id: product_id, title: title, logo: arraybyte, description: description, price: price , categoryName: category_name)
        URLSession.shared.dataTask(with: base_api().saveproduct(data: productto))
        { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            
            guard let data = data , error == nil, urlresponse != nil else {
                print ("can not download check internet")
                DispatchQueue.main.async {
                    
                    self.showToast(message: "check internet")
                    self.loading_hide()
                    
                }
                return
            }
            print ("downloaded")
            base_api().printstring(data: data)
            do
            {
                self.loading_hide()
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    
                    DispatchQueue.main.async {
                        self.havechange = true
                        self.showToast(message: "Your Ptoduct Is Saved")
                        
                        self.performSegue(withIdentifier: "backtoprovidershopfromaddproduct", sender: self)
                        
                    }
                }
                    
                else{
                    DispatchQueue.main.async {
                        //auth_token error
                        print ( downloads.status!)
                        self.showToast(message: "Cannot Save Your Product")
                        
                        let exitalert = UIAlertController.init(title: "Session Expired", message: "You need to login again", preferredStyle: .alert)
                        
                        let yes = UIAlertAction.init(title: "Login", style: .default, handler: { action in
                            self.performSegue(withIdentifier: "backtologinfromaddproduct", sender: self)
                        })
                        
                        let no = UIAlertAction.init(title: "Cancel", style: .default, handler: nil )
                        
                        exitalert.addAction(yes)
                        exitalert.addAction(no)
                        
                        self.present(exitalert, animated: true, completion: nil)
                        
                        
                    }
                }
            }catch {
                print ("json decoder error ")
                DispatchQueue.main.async {
                    self.showToast(message: "json decoder error")
                    
                    
                }
            }
            }.resume()
        
    }
    
    ////************* end of save product ***********
    
    //// ********* delete product *******
    
    func delete_product (auth_token : String , product_id : String){
        let base_url = URL(string :"http://213.175.200.32:8080/Shops/shops/products/delete")
        guard let downloadurl = base_url else {return}
        var request = URLRequest(url: downloadurl, cachePolicy:.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        var json : [String : String]
        json = ["auth_token" : auth_token , "productId" : product_id ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json , options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        base_api().printstring(data: jsonData!)
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            
            guard let data = data , error == nil, urlresponse != nil else {
                print ("can not download check internet")
                DispatchQueue.main.async {
                    self.showToast(message: "Check Your Internet")
                    self.loading_hide()
                }
                return
            }
            print ("downloaded")
            
            do
            {
                self.loading_hide()
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    
                    DispatchQueue.main.async {
                        self.showToast(message: "Your Ptoduct is Deleted")
                        self.havechange = true
                        
                        self.performSegue(withIdentifier: "backtoprovidershopfromaddproduct", sender: self)
                    }
                }
                    
                else{
                    DispatchQueue.main.async {
                        //auth_token error
                        print ( downloads.status!)
                        self.showToast(message: "Not Deleted")
                        
                    }
                }
            }catch {
                print ("json decoder error ")
                self.showToast(message: "Errorr")
                
            }
            }.resume()
        
    }
    
    ////************* end of delete product ***********
    func loading_show(){
        load = MBProgressHUD.showAdded(to: self.view, animated: true)
        load.mode = .indeterminate
        load.label.text = "loading"
        self.view.isUserInteractionEnabled = false
        self.navigationItem.hidesBackButton = true
    }
    func loading_hide(){
        DispatchQueue.main.async {
            self.load.hide(animated: true)
            self.view.isUserInteractionEnabled = true
            self.navigationItem.hidesBackButton = false
            
        }
    }
}

