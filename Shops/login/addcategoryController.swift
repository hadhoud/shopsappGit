

import UIKit


class productCell: UITableViewCell {
    
    @IBOutlet weak var productlistimage: UIImageView!
    @IBOutlet weak var productlisttitle: UILabel!
    @IBOutlet weak var heightforcardview: NSLayoutConstraint!
    func getheight() -> CGFloat {
        return self.heightforcardview.constant
    }
}

class addcategoryController: UIViewController , UITableViewDataSource , UITableViewDelegate ,UITextFieldDelegate {
    
    @IBOutlet weak var addproductcategorytext:  hhstextfield!
    @IBOutlet var tblView: UITableView!
    
    // variable
    var cellheight: CGFloat = 80
    var load = MBProgressHUD()
    var data : [String : Any] = [ "row" : -1]
    var listproduct = [products]()
    var getproduct : products?
    var productfromadd : products?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addproductcategorytext.delegate = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
        // add click for category
        self.addproductcategorytext.overlaybutton.addTarget(self, action: #selector(self.categoryclicked), for: .touchUpInside)
        
    }
    
    @objc func categoryclicked() {
        performSegue(withIdentifier: "tocategorytablefromcategoryproductlist", sender: self)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    // upload button press
    @IBAction func uplaod(_ sender: Any) {
        self.addproductcategorytext.iscategorybool = true
        self.addproductcategorytext.checknoempty()
        var listnotempty = false
        if listproduct.count > 0 {
            listnotempty = true
        }
        if addproductcategorytext.noemptybool && listnotempty
        {
        self.loading_show()
            
            self.save_category()
        }
        else
        {
            self.showToast(message: "Choose A category")
        }
    }
    
    
    
    // show the table
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let emptyLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        if listproduct.count > 0 {
            self.tblView.backgroundView = nil
            return listproduct.count
        }
        else {
            
            emptyLabel.text = "Choose your Category then Press Button Add(+) to add your product list"
            emptyLabel.textAlignment = NSTextAlignment.center
            emptyLabel.numberOfLines = 3
            self.tblView.backgroundView = emptyLabel
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellheight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! productCell
        
        cell.productlistimage.getlogofrombytearray(byteint8: listproduct[indexPath.row].logo ?? [])
        cell.productlisttitle.text = listproduct[indexPath.row].title
        cell.selectionStyle = .none
        cellheight = cell.getheight() + CGFloat(14)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        getproduct = products.init(title: listproduct[indexPath.row].title!, logo: listproduct[indexPath.row].logo!, description: listproduct[indexPath.row].description!, price: listproduct[indexPath.row].price!)
        
        data = [ "row" : indexPath.row ]
        performSegue(withIdentifier: "toaddproducttolistfromaddcategory", sender: self)
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteaction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action,index) in self.deleteproductfromlist(index: indexPath.row , indexp: indexPath)})
        
        return [deleteaction]
    }
    
    // delete product from list
    func deleteproductfromlist(index: Int , indexp: IndexPath){
        listproduct.remove(at: index)
        // listcategory.remove(at: index)
        tblView.deleteRows(at: [indexp], with: .left)
    }
    
    
    
    // prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier! {
        case "toaddproducttolistfromaddcategory":
            if let toaddproductfromproductlist = segue.destination as? addproductforcategorylistViewController {
                toaddproductfromproductlist.myaddproducts = getproduct
                toaddproductfromproductlist.editstep = true
                toaddproductfromproductlist.data = self.data
                
            }
        case "tocategorytablefromcategoryproductlist" :
            if let categorytable = segue.destination as? CategoryTableViewController {
                categorytable.fromsearchbool = "categoryproductlist"
            }
        case "backtoproviderfromaddcategorylist":
            if segue.destination is ProvidershopinfoViewController {
                if let toprovider = segue.destination as? ProvidershopinfoViewController {
                    toprovider.needrefresh = true
                }
            }
        default:
            print("default switch prepare segue")
            break;
            
            
        }
    }
    
    // unwind segue
    @IBAction func Addcategoryproductlistunwind(sender: UIStoryboardSegue)
    {
        if sender.source is addproductforcategorylistViewController {
            if let fromaddproduct = sender.source as? addproductforcategorylistViewController {
                
                if fromaddproduct.editstep {
                    print("editstep:\(fromaddproduct.editstep)")
                    listproduct[fromaddproduct.data["row"] as! Int] = productfromadd!
                }
                else
                {
                    print("editstep:\(fromaddproduct.editstep)")
                    listproduct.append(productfromadd!)
                    print("aftererrorr")
                }
                self.tblView.reloadData()
            }
            
        }
        else if sender.source is CategoryTableViewController {
            if let fromcategory = sender.source as? CategoryTableViewController {
                self.addproductcategorytext.text = fromcategory.categorychoosed
            }
        }
        
    }
    
    
    //// ********* save list of  product *******
    
    func save_category (){
        
        let tosend = category_save.init(auth_token: base_api().load(key: "token"), name: self.addproductcategorytext.text ?? " ", products: listproduct)
        URLSession.shared.dataTask(with: base_api().save_category(data: tosend)) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            DispatchQueue.main.async {
                self.loading_hide()
               
                
            }
            guard let data = data , error == nil, urlresponse != nil else {
                print ("can not download check internet")
                DispatchQueue.main.async {
               
                    self.showToast(message: "Check Your Internet")
                 
                }
                return
            }
            print ("downloaded")
            
            do
            {
           
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    
                    DispatchQueue.main.async {
                        self.showToast(message: "done")
                        self.performSegue(withIdentifier: "backtoproviderfromaddcategorylist", sender: self)
                        // self.performSegue
                    }
                }
                    
                else{
                    DispatchQueue.main.async {
                        //auth_token error
                        print ( downloads.status!)
                        self.showToast(message: "Not ADDED")
                        
                    }
                }
            }catch {
                print ("json decoder error ")
                self.showToast(message: "Errorr")
                
            }
            }.resume()
        
    }
    
    ////************* end of save product list ***********
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


