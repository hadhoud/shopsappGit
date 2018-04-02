
import UIKit

class getpassword: UIViewController {
    @IBOutlet var email: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet var send_mail: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func editing(_ sender: Any) {
        if email.text != "" {
            send_mail.isHidden = false
            email.selectedTitle = "       email"
            email.selectedTitleColor = UIColor.black
            email.imag = nil
        }else { send_mail.isHidden = true}
    }
    @IBAction func send(_ sender: Any) {
        email.checkemail()
        email.checknoempty()
        if email.noemptybool && email.emailtruebool {
            // send to server
            send_mail_to_server()
        }
        else {
            email.selectedTitle = "Enter valid email address"
            email.selectedTitleColor = UIColor.red
            email.imag = #imageLiteral(resourceName: "falsered")
        }
    }
    func send_mail_to_server (){
        self.view.endEditing(true)
        loading_show()
        URLSession.shared.dataTask(with: base_api().get_password(email: self.email.text ?? "")) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            DispatchQueue.main.async {
                
                self.loading_hide() }
            guard let data = data , error == nil, urlresponse != nil else {
                DispatchQueue.main.async {
                    //change something OK
                self.email.selectedTitle = "No Internet Access"
                self.email.selectedTitleColor = UIColor.red
               self.email.isSelected = true
                }
                return
            }
           
            print ("downloaded")
            do
            { //print(data)
                let downloads = try decoder.decode(Res_data.self, from: data)
                if downloads.status == "OK" {
                  
                        DispatchQueue.main.async {
                            self.showalert(title: "Successful" , message: "Please check your inbox, try to login again.")
                            
                        
                    }
                }
                else {
                    DispatchQueue.main.async {
                        //status not ok
                       self.showalert(title: "Fail", message: "This email is not registered or not varified, please try again later")
                    }
                }
                
            }
            catch {
                print ("json decoder error ")
                self.navigationController?.popViewController(animated: true)
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
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            
        })
        
        let no = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(yes)
       alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
