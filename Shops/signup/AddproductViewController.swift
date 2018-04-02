
import UIKit

class AddproductViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate  {
    
    @IBOutlet weak var savebutton: UIButton!
    @IBOutlet weak var addproductdescription: hhstextview!
    @IBOutlet weak var addproductpricetext: hhstextfield!
    @IBOutlet weak var addproductlogo: UIImageView!
    @IBOutlet weak var addproductcategorytext:  hhstextfield!
    @IBOutlet weak var addproducttitletext: hhstextfield!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var editstep: Bool = false
    var data : [String : Any] = ["category_name" : " " , "row" : -1]
    
    var add_category : categories?
    var myaddproducts : productme?
    var imagechanged: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addproductpricetext.delegate = self
        self.addproducttitletext.delegate = self
        self.addproductcategorytext.delegate = self
       
        addobservers()
        self.addproductcategorytext.overlaybutton.addTarget(self, action: #selector(self.categoryclicked), for: .touchUpInside)
        // Do any additional setup after loading the view.
        if editstep {
            filldata()
        }
    }
    
    @IBAction func addproductsaveclicked(_ sender: UIButton) {
        let load = MBProgressHUD.showAdded(to: self.view, animated: true)
        load.mode = .indeterminate
        load.label.text = "Waiting..."
        load.show(animated: true)
        addproducttitletext.checknoempty()
        addproductpricetext.checknoempty()
        addproductcategorytext.iscategorybool = true
        addproductcategorytext.checknoempty()
        
        if imagechanged {
        if addproductcategorytext.noemptybool && addproducttitletext.noemptybool &&  addproductcategorytext.noemptybool && addproductpricetext.noemptybool && imagechanged {
            print("truechecked")
            
            //************
            let product = products.init( title: addproducttitletext.text ?? "", logo: base_api().toarrayofbyte(image: addproductlogo.image ?? #imageLiteral(resourceName: "noImage")), description: addproductdescription.gettext(), price: Int( addproductpricetext.text ?? "0") ?? 0)
           
            add_category = categories.init(name: addproductcategorytext.text ?? " ", products: [product])

            myaddproducts = productme(id: 1, title: addproducttitletext.text!, price: addproductpricetext.text!, img: addproductlogo.image!, description: addproductdescription.gettext())
            load.hide(animated: true)
            // perform unwind segue from addproduct
            performSegue(withIdentifier: "backtoproductlist", sender: self)
        }
            else
                {
                    load.hide(animated: true)
                     self.showToast(message: "Fill All the fields")
                }
        }
        else {
             load.hide(animated: true)
            self.showToast(message: "Choose A Logo")
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
            self.addproductlogo.image = image
            imagechanged = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func categoryclicked() {
        performSegue(withIdentifier: "tocategoryfromaddproductsignup", sender: self)
    }
    
    func filldata(){
        self.imagechanged = true
        self.savebutton.setTitle("Done", for: .normal)
        self.navigationController?.title = "Edit Product"
        self.addproductcategorytext.text = data["category_name"] as? String
        self.addproducttitletext.text = myaddproducts?.title
        self.addproductlogo.image = myaddproducts?.img
        self.addproductpricetext.text = myaddproducts?.price
        self.addproductdescription.text = myaddproducts?.description
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "tocategoryfromaddproductsignup":
            if let destination = segue.destination as? CategoryTableViewController {
                destination.fromsearchbool = "addsignup"
            }
        default:
            break
        }
    }
    
    @IBAction func unwindfromcategorytable(sender: UIStoryboardSegue)
    {
        if sender.source is CategoryTableViewController {
            if let getcategory = sender.source as? CategoryTableViewController {
                self.addproductcategorytext.text = getcategory.categorychoosed
            }
            
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addobservers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeobservers()
    }
    //click on view hide keyboard
    
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

