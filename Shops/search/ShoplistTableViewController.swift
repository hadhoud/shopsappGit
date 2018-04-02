
import UIKit
class ShoplistTablecell: UITableViewCell {
    
    @IBOutlet weak var shoplistimage: UIImageView!
    
    @IBOutlet weak var heightforview: NSLayoutConstraint!
    @IBOutlet weak var shoplistview: UIView!
    @IBOutlet weak var shoplisttitle: UILabel!
    @IBOutlet weak var shoplistdescription: UITextView!
    
    func setcornerforview() {
        self.shoplistview.layer.cornerRadius = 20
        self.shoplistview.layer.masksToBounds = true
    }
    func getheight() -> CGFloat{
        return heightforview.constant
    }
}
class ShoplistTableViewController: UITableViewController {
    var load = MBProgressHUD()
    
    var hightforrow :CGFloat = 90
    var sendedshopinfo : [userinfo]?
    
    var myuserinfoases: [userinfo]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // deleted in json
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myuserinfoases!.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return hightforrow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoplistTablecell", for: indexPath) as! ShoplistTablecell
        
        cell.shoplisttitle.text = myuserinfoases![indexPath.row].shopName ?? ""
        cell.shoplistdescription.text = myuserinfoases![indexPath.row].generalDescription
        cell.shoplistimage.getlogofromurl(myuserinfoases![indexPath.row].logo ?? "")
        
        hightforrow = cell.getheight() + 20
        
       // cell.setcornerforview()
//        let selectionview = UIView()
//        selectionview.backgroundColor = UIColor.init(red: 84/255, green: 47/255, blue: 82/255, alpha: 1.0)
//        selectionview.layer.cornerRadius = 20
//        selectionview.layer.masksToBounds = true
//        cell.selectedBackgroundView = selectionview
        cell.selectionStyle = .none
        cell.selectedBackgroundView = nil
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get selected shop at specific index
        getshopinfo(token: myuserinfoases![indexPath.row].authToken!)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShopinfoViewController {
            
            destination.shopinfo = sendedshopinfo
        }
    }
    //******************************* get shop infos ******************
    func getshopinfo (token : String ){
        let request = base_api().get_info_request(token: token, include_non_approved_categories: 0)
        self.loading_show()
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            
            
            guard let data = data , error == nil, urlresponse != nil else {
                // print ("can not download check internet")
                DispatchQueue.main.async {
                    
                 self.loading_hide()
                    self.showToast(message: "No Internet")}
                return
                
                
            }
            base_api().printstring(data: data)
            // print ("downloaded")
            do
            {
                self.loading_hide()
                print(data.description)
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    
                    DispatchQueue.main.async {
                       
                        if downloads.user_infos != nil {
                            self.sendedshopinfo = downloads.user_infos
                            self.performSegue(withIdentifier: "toshopdetails", sender: self)
                            
                        }
                    }
                }
                    
                else{
                   
                        print ( "error ")
                        
                    
                }
            }catch {
                    print ("json decoder error ")}
            
            }.resume()
        
    }
    
    //************************************** end of get class
    
    
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

