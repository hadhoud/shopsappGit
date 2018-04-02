

import UIKit


class EditProfile:  UITableViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @IBOutlet var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var shopname: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var phone: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var mobile: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var whatsapp: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var address: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var website: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var generalDescriptions: hhstextview!
    @IBOutlet var password: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var username: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var logo : hhsimage!
    
    var info : [userinfo]? = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loaddata()
    
    }

    @IBAction func signuplogoclicked(_ sender: UITapGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.logo.image = image
          
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func loaddata (){
        
        shopname.text = info![0].shopName ?? "123"
        phone.text = info![0].phone ?? "123"
        mobile.text = info![0].mobile ?? "123"
        whatsapp.text = info![0].whatsapp ?? "123"
        address.text = info![0].address ?? "123"
        website.text = info![0].website ?? "123"
        generalDescriptions.text = info![0].generalDescription ?? "123"
        username.text = info![0].username ?? "123"
        password.text = info![0].passwd ?? "123"
        email.text = info![0].email ?? "123"
        logo.getlogofromurl(info![0].logo ?? "")
    }
    
    @IBAction func send(_ sender: Any) {
        self.loading_show()
 DispatchQueue.main.async {
        self.editprofile()
        }
        
    }
    
    
    func editprofile() {
 
        
    var jsondata  = ["longitude": info![0].longitude!,"latitude":info![0].latitude ?? "", "googleToken": "123456","email" : email.text ?? "" , "shopname" : shopname.text ,"phone":phone.text , "mobile":mobile.text, "whatsapp":whatsapp.text,"address":address.text , "website":website.text ,"auth_token":info![0].authToken , "description":generalDescriptions.text,"username":username.text,"password":password.text ,"logo":base_api().toarrayofbyte(image: logo.image!)] as [String:Any]
      
   
        let url = URL(string :"\(base_api().base_url)/Shops/shops/user/register")
        let json = try? JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
    
   // base_api().printstring(data: json!)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!
        
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            DispatchQueue.main.async {
               self.loading_hide()
            }
            guard let data = data , error == nil, urlresponse != nil else {
                //print ("can not download check internet")
                DispatchQueue.main.async {
                    
                    self.showToast(message: "No Internet")}
                
                return
            }
            //   print ("downloaded")
           // base_api().printstring(data: data)
            do
            {
                
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    DispatchQueue.main.async {
                       self.performSegue(withIdentifier: "back", sender: self)

                   self.showToast(message: "Thank you")
                       
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
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                    self.showToast(message: "Try again later")
                    
                }
            }
            
            }.resume()
        
    }
    var load = MBProgressHUD()
    func loading_show(){
        load = MBProgressHUD.showAdded(to: self.view, animated: true)
        load.mode = .indeterminate
        load.label.text = "loading"
        self.view.isUserInteractionEnabled = false
        self.navigationItem.hidesBackButton = true
        self.view.endEditing(true)
    }
    func loading_hide(){
        DispatchQueue.main.async {
            self.load.hide(animated: true)
            self.view.isUserInteractionEnabled = true
            self.navigationItem.hidesBackButton = false
            
        }
    }
    func showalert(title : String , message : String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let yes = UIAlertAction.init(title: "OK", style: .default, handler: { action in
            
            
        })
        
        let no = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        // back to shopproviderinfo
        case "back":
            if let providershop = segue.destination as? ProvidershopinfoViewController {
                
                    providershop.needrefresh = true
                    
                }
            
            
        default:
            break
        }
        
    }
 
}
