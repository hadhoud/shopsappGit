//
//  LoginViewController.swift
//  collection
//
//  Created by Admin on 25/11/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var checkbox: UICheckbox!
    @IBOutlet weak var loginview: UIView!
   
    @IBOutlet var passwordtextfield: hhstextfield!
    
    @IBOutlet var Usernametext: hhstextfield!
    var load = MBProgressHUD()
    var sendedtoprovider : [userinfo]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Usernametext.delegate = self
        self.passwordtextfield.delegate = self
        Observekeyboardnotification()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Observekeyboardnotification()
        self.tabBarController?.tabBar.items![1].title = "Login"
        if  !(base_api().load(key: "username") == "") {
        let pass = base_api().load(key: "password")
            let user = base_api().load(key: "username")
            self.Usernametext.text = user
            self.passwordtextfield.text = pass
            self.checkbox.isSelected = true
        }
        else {
            self.Usernametext.text = ""
            self.passwordtextfield.text = ""
            self.checkbox.isSelected = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeobservers()
    }
    
    @IBAction func loginUnwindAction(unwindSegue: UIStoryboardSegue)
    {
     
    }
    @IBAction func loginbutton(_ sender: Any) {
        self.view.endEditing(true)
        self.Usernametext.checknoempty()
        self.passwordtextfield.checknoempty()
        if Usernametext.noemptybool && passwordtextfield.noemptybool {
            if self.checkbox.isSelected {
                base_api().save(key: "username", value:  self.Usernametext.text!)
                base_api().save(key: "password", value: self.passwordtextfield.text!)
            }
            else
            {
                base_api().save(key: "username", value: "")
                base_api().save(key: "password", value: "")
            }
            load = MBProgressHUD.showAdded(to: self.view, animated: true)
            load.mode = .indeterminate
            self.view.isUserInteractionEnabled = false
            load.label.text = "Waiting..."
            login(username:Usernametext.text!, password: passwordtextfield.text!)
          
        }
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProvidershopinfoViewController{
            destination.providershopinfo = sendedtoprovider
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    // add observers
    fileprivate func Observekeyboardnotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardshow), name: .UIKeyboardWillShow , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhide), name: .UIKeyboardWillHide , object: nil)
        
    }
    func removeobservers()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // hide keyboard when view clicked
    @IBAction func viewpressed(_ sender: Any) {
        view.endEditing(true)
    }
    
    // hide keyboard
    @objc func keyboardhide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
                self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                
        }, completion: nil)
    }
    // show keyboard
    
    @objc func keyboardshow(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
                self.view.frame = CGRect.init(x: 0, y: -40, width: self.view.frame.width, height: self.view.frame.height)
                
        }, completion: nil)
    }
    
    // login
    func login (username : String , password : String ){
        let request = base_api().login_request(username: username, password: password)
        
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            guard let data = data , error == nil, urlresponse != nil else {
                print ("can not download check internet")
                DispatchQueue.main.async {
                    self.showToast(message: "Check Your Internet")
                    self.load.hide(animated: true)
                    self.view.isUserInteractionEnabled = true
                }
                return
            }
            print ("downloaded")
            do
            {
                let downloads = try decoder.decode(Res_data.self, from: data)
                if downloads.status == "OK" {
                    
                    DispatchQueue.main.async {
                        print(downloads.auth_token!)
                        ////// new
                        base_api().save(key: "token", value: downloads.auth_token!)
                        // do something
                        self.getshopinfo(token: downloads.auth_token!)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        
                        self.showToast(message: "Wrong Username OR Password")
                        self.load.hide(animated: true)
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }catch {
                print ("json decoder error ")
                self.load.hide(animated: true)
                self.view.isUserInteractionEnabled = true
            }
            }.resume()
        
    }
    //
    ////************************************** end of login
    
    //******************************* get shop infos ******************
    func getshopinfo (token : String ){
        let request = base_api().get_info_request(token: token, include_non_approved_categories: 1)
        
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            
            guard let data = data , error == nil, urlresponse != nil else {
                print ("can not download check internet")
                DispatchQueue.main.async {
                    
                    self.showToast(message: "Check Your Internet")
                    self.load.hide(animated: true)
                    self.view.isUserInteractionEnabled = true
                }
                return
            }
            print ("downloaded")
            do
            {
                print(data.description)

                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    
                    DispatchQueue.main.async {
                        
                        self.sendedtoprovider = downloads.user_infos
                       // base_api().printstring(data: try! JSONEncoder().encode(downloads))
                        self.load.hide(animated: true)
                        self.view.isUserInteractionEnabled = true
                        self.performSegue(withIdentifier: "toprovidershopinformation", sender: self)
                    }
                }
                    
                else{
                    DispatchQueue.main.async {
                        
                        self.showToast(message: "canot get user info")
                        self.load.hide(animated: true)
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }catch {
                self.showToast(message: "json decoder error ")
                self.load.hide(animated: true)
                self.view.isUserInteractionEnabled = true
            }
            }.resume()
        
    }
    
    //************************************** end of get class
}

