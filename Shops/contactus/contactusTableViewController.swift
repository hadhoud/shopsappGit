//
//  contactusTableViewController.swift
//  Shops
//
//  Created by Admin on 12/21/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit

class contactusTableViewController: UITableViewController , UITextFieldDelegate , UIPickerViewDelegate , UIPickerViewDataSource {
    
    @IBOutlet weak var phone: hhstextfield!
    @IBOutlet weak var email: hhstextfield!
    @IBOutlet weak var type: hhstextfield!
    @IBOutlet weak var email_title: hhstextfield!
    @IBOutlet weak var descritptions: hhstextview!
 
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

        let user_token = base_api().load(key : "token")
        
        if phone.validate() && !(self.descritptions.gettext() == "") && email.emailtruebool{
            
            
            contactus(auth_token: user_token, email_title: email_title.text ?? " ", email_type: type.text ?? " " , description: descritptions.gettext() , email: email.text ?? " ", phone: phone.text ?? " ")
            
        }
        else
        {
            self.showToasttable(message: "Fill all The Fields")
        }
        
    }
    func cleartext(){
        self.email.text = ""
        self.email_title.text = ""
        self.type.text = ""
        self.phone.text = ""
        self.descritptions.text = ""
    }
   
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
    
   
    
    @IBAction func viewclickedforkeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
  
    
    
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
        self.view.endEditing(true)
        let base_url = URL(string :"\(base_api().base_url)/Shops/shops/user/contact_us")
        
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
            DispatchQueue.main.async {
                self.load.hide(animated: true)
                self.view.isUserInteractionEnabled = true
               }
            guard let data = data , error == nil, urlresponse != nil else {
                //print ("can not download check internet")
                DispatchQueue.main.async {
                    
                    self.showToast(message: "No Internet")}
                return
            }
            //   print ("downloaded")
            
            do
            {
                
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    DispatchQueue.main.async {
                     
                        self.cleartext()
                        self.showToast(message: "Thank you")
                        self.showalert(title: "Thank you", message: "We will take this into consideration.")
                        //print ("ok")
                    }
                }
                else{
                    DispatchQueue.main.async {
                       
                    }
                }
            }catch {
                //print ("json decoder error ")
                DispatchQueue.main.async {
                  
                    self.showToast(message: "Try again later")
                }
            }
            
            }.resume()
        
    }
    func showalert(title : String , message : String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let yes = UIAlertAction.init(title: "OK", style: .default, handler: { action in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            
        })
        
        let no = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    ////************************************** end of contactus ******************************
}
