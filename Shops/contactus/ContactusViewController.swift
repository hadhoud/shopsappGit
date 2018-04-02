

import UIKit

class ContactusViewController: UIViewController , UITextFieldDelegate , UIPickerViewDelegate , UIPickerViewDataSource {
    
    
    @IBOutlet weak var phone: hhstextfield!
    @IBOutlet weak var email: hhstextfield!
    @IBOutlet weak var type: hhstextfield!
    @IBOutlet weak var email_title: hhstextfield!
    @IBOutlet weak var descritptions: hhstextview!
    @IBOutlet weak var scrollview: UIScrollView!
    weak var activeField : UITextField?
    weak var activetextview : UITextView?
    var load = MBProgressHUD()
    let emailtypevalue = ["Complain" , "Comment" , "Suggestion"]
    var pickerview = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phone.delegate = self
         self.email.delegate = self
         self.type.delegate = self
         self.email_title.delegate = self
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        self.type.inputView = pickerview
        
    }
    
    @IBAction func send(_ sender: Any) {
        phone.checknoempty()
        email.checknoempty()
        email.checkemail()
        addobservers()
        let user_token = base_api().load(key : "token")
        
        if phone.validate() && !(self.descritptions.gettext() == "") && email.emailtruebool{
            
            
            contactus(auth_token: user_token, email_title: email_title.text ?? " ", email_type: type.text ?? " " , description: descritptions.gettext() , email: email.text ?? " ", phone: phone.text ?? " ")
            
        }
        else
        {
            self.showToast(message: "Fill all The Fields")
        }
        
    }
   func cleartext(){
    self.email.text = ""
    self.email_title.text = ""
    self.type.text = ""
    self.phone.text = ""
    self.descritptions.text = ""
    }
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        self.activetextview = textView
//        return true
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        self.activetextview = nil
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
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
        self.scrollview.contentInset = UIEdgeInsets.zero
    }
    
    //show keyboard scrolling
    func keyboardshow(notification: Notification){
    
        guard let userinfo = notification.userInfo , let frame = (userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let keyboardViewEndFrame = view.convert(frame, from: view.window)
        let contentinset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardViewEndFrame.height , right: 0.0)
        self.scrollview.contentInset = contentinset
        self.scrollview.scrollIndicatorInsets = contentinset
//        var aRect = self.view.frame
//        aRect.size.height -= frame.size.height
//
//        if let activeField = self.activeField
//            {
//
//        if (!aRect.contains(activeField.frame.origin)) {
//            self.scrollview.scrollRectToVisible(activeField.frame, animated: true)
//                }
//            }
//      if let activetextview = self.activetextview {
//        let point = CGPoint.init(x: activetextview.frame.origin.x + 20, y: activetextview.frame.origin.y + 20)
//
//            if (!aRect.contains(point)) {
//                self.scrollview.scrollRectToVisible(activetextview.frame, animated: true)
//            }
//        }
}
    //***************************************************************
  
    
    // picker delegate datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return emailtypevalue.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return emailtypevalue[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.type.text = emailtypevalue[row]
        self.type.resignFirstResponder()
    }
    
    
    
    // ************************** contact us ********************
    
    func contactus (auth_token : String , email_title : String, email_type: String , description : String , email : String ,phone : String){
        
        load = MBProgressHUD.showAdded(to: self.view, animated: true)
        load.mode = .indeterminate
        load.label.text = "loading"
        self.view.isUserInteractionEnabled = false
        
        let base_url = URL(string :"http://213.175.200.32:8080/Shops/shops/user/contact_us")
        
        guard let downloadurl = base_url else {return}
        var request = URLRequest(url: downloadurl, cachePolicy:.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        var json : [String : String]
        json = ["auth_token" : auth_token , "emailTitle" : email_title , "emailType" : email_type , "description" : description , "email" : email , "phoneNumber" : phone ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json , options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        base_api().printstring(data: jsonData!)
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            guard let data = data , error == nil, urlresponse != nil else {
                //print ("can not download check internet")
                DispatchQueue.main.async { self.load.hide(animated: true)
                    self.view.isUserInteractionEnabled = true
                    self.showToast(message: "No Internet")}
                return
            }
            //   print ("downloaded")
            
            do
            {
                
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    DispatchQueue.main.async {
                        self.load.hide(animated: true)
                        self.view.isUserInteractionEnabled = true
                        self.cleartext()
                        self.showToast(message: "Thank you")
                        
                        //print ("ok")
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.load.hide(animated: true)
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }catch {
                //print ("json decoder error ")
                DispatchQueue.main.async {
                    self.load.hide(animated: true)
                    self.view.isUserInteractionEnabled = true
                    self.showToast(message: "Try again later")
                }
            }
            
            }.resume()
        
    }
    
    ////************************************** end of contactus ******************************
}



