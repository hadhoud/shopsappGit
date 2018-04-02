
import UIKit

protocol DataBackDelegate: class {
    func savePreferences (category : [categories] , p : [productme])
}

class SignupcontactViewController: UIViewController , UITextViewDelegate , UITextFieldDelegate , DataBackDelegate{
    func savePreferences(category: [categories] , p : [productme]) {
        list_of_categories = category
        listproduct1 = p
        base_api().printstring(data: try! JSONEncoder().encode(list_of_categories))
    }
    
    @IBOutlet var phone: UITextField!
    @IBOutlet var mobile: UITextField!
    @IBOutlet var whatsapp: UITextField!
    @IBOutlet var email: hhstextfield!
    @IBOutlet var website: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var descriptions: hhstextview!
    @IBOutlet var scrollview: UIScrollView!
   
    @IBOutlet var back: UIBarButtonItem!
    var load = MBProgressHUD()
    
    
    
    var listproduct1 = [productme]()
    var datafromfirst : [String : String] = [:]
    var logofromfirst: [Int8] = []
    var registration_data : registration?
    var location : [String : Double] = [:]
    var list_of_categories : [categories] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addobservers()
        self.phone.delegate = self
        self.mobile.delegate = self
        self.whatsapp.delegate = self
        self.email.delegate = self
        self.website.delegate = self
        self.address.delegate = self
        self.descriptions.delegate = self
        
    }
    
    @IBAction func Register(_ sender: Any) {
        fill_and_register()
        
    }
    @IBAction func back(_sender: UIBarButtonItem)
    {
        let exitalert = UIAlertController.init(title: "Warning", message: "Your products will be lossed?", preferredStyle: .alert)
        
        let yes = UIAlertAction.init(title: "Yes", style: .default, handler: { action in
            self.performSegue(withIdentifier: "backtosignupfirstfromsignupcontact", sender: self)
        })
        
        let no = UIAlertAction.init(title: "No", style: .default, handler: { action in
            
        })
        
        exitalert.addAction(yes)
        exitalert.addAction(no)
        
        self.present(exitalert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? productlistTableViewController {
            destinationViewController.delegate = self
            destinationViewController.listcategory = list_of_categories
            destinationViewController.listproduct = listproduct1
            
        }    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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
    
    func fill_and_register (){
        
registration_data = registration.init(shopname: datafromfirst["shopName"] ?? "" , description: descriptions.gettext() , logo: logofromfirst , latitude: location["latitude"] ?? 0.0 , longitude: location["longitude"] ?? 0.0 , username: datafromfirst["userName"] ?? "" , password: datafromfirst["password"] ?? "" , phone:phone.text ?? "" , mobile:mobile.text ?? "", whatsapp:whatsapp.text ?? "" , email: email.text ?? "" , website:website.text ?? "", address:address.text ?? " ", googletoken: "123456" ,categories : sorted_category())
        
        let request = base_api().register_request(data: registration_data!)
     self.loading_show()
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            
            
            guard let data = data , error == nil, urlresponse != nil else {
                print (" check internet connection")
                DispatchQueue.main.async {
                    self.loading_hide()
                    self.showToast(message: "please check your internet")}
                return
            }
            do
            {
                DispatchQueue.main.async {
                   self.loading_hide()}
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "backtologinfromsignupregister", sender: self)
                        //  print("registration ok")
                        
                    }
                }
                    
                else{
                    DispatchQueue.main.async {
                        self.showToast(message: "please try again later")
                        //print ( "error registring")
                        
                    }
                }
            }catch {
                DispatchQueue.main.async {
                    self.showToast(message: "please try again later")
                    //  print ("json decoder error ")
                }}
            }.resume()
        
    }
    
    //************************************** end of get class
    
    func  sorted_category ()->[categories]{
        
        var temp : [categories] = []
        temp.removeAll(keepingCapacity: false)
        var flag = false
        for i in list_of_categories {
            flag = false
            var count = 0
            for j in temp {
                if i.name == j.name{
                    flag = true
                    temp[count].products!.append(i.products![0])
                    break
                }
                count = count + 1
                
            }
            if !flag {
                
                temp.append(i)
            }
            
        }
        
        return temp
    }
    
    
    
    
    
    func loading_show(){
        load = MBProgressHUD.showAdded(to: self.view, animated: true)
        load.mode = .indeterminate
        load.label.text = "loading"
        self.view.isUserInteractionEnabled = false
       self.back.isEnabled = false
    }
    func loading_hide(){
        DispatchQueue.main.async {
            self.load.hide(animated: true)
            self.view.isUserInteractionEnabled = true
          self.back.isEnabled = true
            
        }
    }
}

