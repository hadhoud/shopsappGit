
import UIKit
class productlistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productlistimage: UIImageView!
    
    @IBOutlet weak var productlisttitle: UILabel!
}

class productlistTableViewController: UITableViewController  {
    var delegate : DataBackDelegate?
    var data : [String : Any] = ["category_name" : " " , "row" : -1]
    
    var listproduct = [productme]()
    var getproduct : productme?
    
    var listcategory = [categories]()
    var getcategory : category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let emptyLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        if listproduct.count > 0 {
            self.tableView.backgroundView = nil
            return listproduct.count
        }
        else {
            
            emptyLabel.text = "Press Button Add(+) and start add product"
            emptyLabel.textAlignment = NSTextAlignment.center
            emptyLabel.numberOfLines = 3
            self.tableView.backgroundView = emptyLabel
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productlist", for: indexPath) as! productlistTableViewCell
        cell.productlistimage.image = listproduct[indexPath.row].img
        cell.productlisttitle.text = listproduct[indexPath.row].title
        
        cell.selectionStyle = .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getproduct = productme(id: 1, title: listproduct[indexPath.row].title, price: listproduct[indexPath.row].price, img: listproduct[indexPath.row].img, description: listproduct[indexPath.row].description)
        data = ["category_name" : listcategory[indexPath.row].name ?? "" , "row" : indexPath.row ]
        performSegue(withIdentifier: "toaddproductfromproductlist", sender: self)
        
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteaction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(action,index) in self.deleteproductfromlist(index: indexPath.row , indexp: indexPath)})
        
        return [deleteaction]
    }
    
    func deleteproductfromlist(index: Int , indexp: IndexPath){
        listproduct.remove(at: index)
        listcategory.remove(at: index)
        tableView.deleteRows(at: [indexp], with: .left)
    }
    @IBAction func unwindfromaddproduct(sender: UIStoryboardSegue)
    {
        if sender.source is AddproductViewController {
            if let fromaddproduct = sender.source as? AddproductViewController {
                if fromaddproduct.editstep {
                   
                    listproduct[fromaddproduct.data["row"] as! Int] = fromaddproduct.myaddproducts!
                    listcategory[fromaddproduct.data["row"] as! Int] = fromaddproduct.add_category!
                }
                else {
                   
                    listproduct.append(fromaddproduct.myaddproducts!)
                    listcategory.append(fromaddproduct.add_category!)
                    
                }
            }
            tableView.reloadData()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier! {
        case "toaddproductfromproductlist":
            if let toaddproductfromproductlist = segue.destination as? AddproductViewController {
                toaddproductfromproductlist.navigationController?.title = "Edit Product"
                toaddproductfromproductlist.myaddproducts = getproduct
                toaddproductfromproductlist.editstep = true
                toaddproductfromproductlist.data = self.data
                
            }
            
        default:
            
            print("default switch prepare segue")
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.savePreferences(category: listcategory , p : listproduct)
    }
}

