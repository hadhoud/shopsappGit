
import UIKit
//table View Cell
class ProvidershopinfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var providercollectionview: UICollectionView!
    @IBOutlet weak var providercategorytitle: UILabel!
    
    func registerCollectionview<DataSource:UICollectionViewDataSource>(datasource:DataSource){
        
        self.providercollectionview.dataSource = datasource
        
    }
    func registerCollectionviewdelegate<Delegate:UICollectionViewDelegate>(delegate:Delegate){
        self.providercollectionview.delegate = delegate
        
    }
    func reload()
    {
        self.providercollectionview.reloadData()
    }
}
// collection view cell
class Providershopinfocollectionviewcell: UICollectionViewCell {
    
    @IBOutlet weak var providershopinfoproductimage: UIImageView!
    @IBOutlet weak var providerproductname: UILabel!
}

class ProvidershopinfoViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource , UITabBarControllerDelegate {
    
    @IBOutlet weak var providershopinfotableview: UITableView!
    @IBOutlet weak var providerlogo: UIImageView!
    @IBOutlet weak var providershopname: UILabel!
    var providershopinfo : [userinfo]? = []
    var providerarray: [category]!
    var sendedproduct: product?
    var load = MBProgressHUD()
    var needrefresh: Bool = false
    var sendedtoken: String = ""
    var sendedcategoryname: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.providershopinfotableview.delegate = self
        self.providershopinfotableview.dataSource = self
        self.tabBarController?.delegate = self
        self.tabBarController?.tabBar.items![1].title = "MyShop"
        loadshopdetails()
        
    }

    func loadshopdetails (){

        providerlogo.getlogofromurl(providershopinfo![0].logo ?? "" )
        providershopname.text = providershopinfo![0].shopName ?? ""
        providerarray = providershopinfo![0].lstCategories!
        print("\(providerarray)")
    }
    
    
    // Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // remove category with  no product
        providerarray = providershopinfo![0].lstCategories!
        for (index , e) in providerarray.enumerated().reversed(){

            if e.lstProducts?.count == 0
            {
                providerarray.remove(at: index)
            }
        }
      
        let emptyLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        if providerarray.count == 0 {
            emptyLabel.text = "No Products in your shop"
            emptyLabel.textAlignment = NSTextAlignment.center
            emptyLabel.numberOfLines = 3
            tableView.backgroundView = emptyLabel
            return 0
     
        }
            
        else {
            tableView.backgroundView = nil
            return providerarray.count
        }
    }
    
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvidershopinfoTableViewCell", for: indexPath) as! ProvidershopinfoTableViewCell
        cell.registerCollectionview(datasource: self)
        cell.registerCollectionviewdelegate(delegate: self)
        // for reload collection when reload table
        
        cell.reload()
        cell.providercategorytitle.text = providerarray[indexPath.row].name
        cell.selectionStyle = .none
        cell.providercollectionview.tag = indexPath.row
        
        return cell
        
    }
    
    // Collection Horizontal
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count:\(providerarray[collectionView.tag].lstProducts!.count)")
        return  providerarray[collectionView.tag].lstProducts!.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Providershopinfocollectionviewcell", for: indexPath) as! Providershopinfocollectionviewcell

       cell.providershopinfoproductimage.getlogofromurl(providerarray[collectionView.tag].lstProducts![indexPath.row].logo!)
        cell.providerproductname.text = providerarray[collectionView.tag].lstProducts![indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendedtoken = providershopinfo![0].authToken!
        sendedproduct = providerarray[collectionView.tag].lstProducts![indexPath.row]
        sendedcategoryname = providerarray[collectionView.tag].name!
        
        self.performSegue(withIdentifier: "toshowproductfromprovider", sender: self)
        
    }
    
    @IBAction func actionsheetitemclick(_ sender: UIBarButtonItem) {
        let provideractionsheet = UIAlertController.init(title: nil , message: nil , preferredStyle: .actionSheet)
        
        let addaction = UIAlertAction.init(title: "Add Product", style: .default, handler: {action in self.addproductfromaction()})
         let addaction2 = UIAlertAction.init(title: "Add Category of Products", style: .default, handler: {action in self.addcategoryfromaction()})
        
        let closeaction = UIAlertAction.init(title: "Close", style: .cancel, handler: nil)
        provideractionsheet.addAction(addaction)
         provideractionsheet.addAction(addaction2)
        provideractionsheet.addAction(closeaction)
        self.present(provideractionsheet, animated: true, completion: nil)
    }
    
    func addproductfromaction(){
        self.performSegue(withIdentifier: "toaddproductfromprovider", sender: self)
    }
    func addcategoryfromaction(){
        self.performSegue(withIdentifier: "toaddlistofproductfromprovider", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "toaddproductfromprovider":
            if let toaddproduct = segue.destination as? addproductproviderViewController    {
                toaddproduct.showproductbool = false
                sendedtoken = providershopinfo![0].authToken!
                toaddproduct.token = sendedtoken
            }
        case "toshowproductfromprovider":
            if let toshowproduct = segue.destination as? addproductproviderViewController {
                toshowproduct.showproductbool = true
                toshowproduct.productoshow = sendedproduct
                toshowproduct.categoryname = sendedcategoryname
                toshowproduct.token = sendedtoken
                
            }
        
        case "toshopinformationfromshop":
            if let destination = segue.destination as? shopdetailsViewController {
                destination.info = providershopinfo
            }
        case "backtologinfromprovider":
            if segue.destination is LoginViewController {
                base_api().save(key:  "token" , value: " ")
            }
        case "toeditprofile":
            if let destination = segue.destination as? EditProfile {
                destination.info = providershopinfo
            }
            print ("Edit profile")
        default:
            break
        }
    }
    
    @IBAction func infos(_ sender: Any) {
        performSegue(withIdentifier: "toshopinformationfromshop", sender: self)
    }
    //**********
    // unwind segue
    @IBAction func providerunwindsegue(unwindSegue: UIStoryboardSegue)
    {
        if needrefresh {
            
            self.load = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.load.mode = .indeterminate
            self.load.label.text = "Waiting..."
            getshopinfo(token: providershopinfo![0].authToken!)
            
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }
    
    ///
    func getshopinfo (token : String ){
        let request = base_api().get_info_request(token: token, include_non_approved_categories: 1)
        
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            
            guard let data = data , error == nil, urlresponse != nil else {
                print ("can not download check internet")
                DispatchQueue.main.async {
                    
                    self.showToast(message: "Check Your Internet")
                    self.load.hide(animated: true)
                }
                return
            }
            print ("downloaded")
            
            do
            {
                print(data.description)
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    base_api().printstring(data: data)
                    DispatchQueue.main.async {
                  
                        self.providershopinfo = downloads.user_infos
                        self.load.hide(animated: true)
                        print("reload")
                        self.providershopinfotableview.reloadData()
                        self.loadshopdetails()
                    }
                }
                    
                else{
                    DispatchQueue.main.async {
                        
                        self.showToast(message: "canot get user info")
                        self.load.hide(animated: true)
                    }
                }
            }catch {
                self.showToast(message: "json decoder error ")
                self.load.hide(animated: true)
            }
            }.resume()
        print("finish func")
    }
    
    //************************************** end of get class
    
}

