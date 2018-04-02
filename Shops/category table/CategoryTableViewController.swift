//
//  CategoryTableViewController.swift
//  collection
//
//  Created by Admin on 25/11/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit
class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryname: UILabel!
}

class CategoryTableViewController: UITableViewController , UISearchResultsUpdating {
    var load = MBProgressHUD()
    
    
    let searchcontroller = UISearchController(searchResultsController: nil)
    var fromsearchbool: String!
    var mycategories = [category]()
    var filtereddata = [category]()
    var categorychoosed: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchcontroller.searchResultsUpdater = self
        searchcontroller.dimsBackgroundDuringPresentation = false
        // definesPresentationContext = true
        tableView.tableHeaderView = searchcontroller.searchBar
        searchcontroller.hidesNavigationBarDuringPresentation = false
        self.searchcontroller.searchBar.searchBarStyle = .prominent
        //  print(fromsearchbool)
        //  loadSampleMeals()
        load = MBProgressHUD.showAdded(to: self.view, animated: true)
        load.mode = .indeterminate
        load.label.text = "loading"
        self.view.isUserInteractionEnabled = false
        get_all_categories()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let emptyLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
       
        if self.searchcontroller.isActive && searchcontroller.searchBar.text != ""
        {
            if self.filtereddata.count > 0 {
                self.tableView.backgroundView = nil
                
                return filtereddata.count
            }
                
            else {
                
                emptyLabel.text = "No Results For Your Search"
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.numberOfLines = 3
                self.tableView.backgroundView = emptyLabel
                return 0
            }
        }
        else
        {
            if mycategories.count == 0
            {
                emptyLabel.text = "No Categories"
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.numberOfLines = 3
                self.tableView.backgroundView = emptyLabel
                return 0
            }
            else
            {
                self.tableView.backgroundView = nil
                return mycategories.count
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "categorycell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        if self.searchcontroller.isActive && searchcontroller.searchBar.text != "" {
            cell.categoryname.text = filtereddata[indexPath.row].name
        }
        else {
            cell.categoryname.text = mycategories[indexPath.row].name
            
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.searchcontroller.isActive && searchcontroller.searchBar.text != "" {
            categorychoosed = filtereddata[indexPath.row].name!
            
        }
        else
        {
            categorychoosed = mycategories[indexPath.row].name!
        }
       
        if fromsearchbool == "search" {
            self.performSegue(withIdentifier: "backtosearchfromcategorytable", sender: self)
        }
        else if fromsearchbool == "addsignup"
        {
            
            self.performSegue(withIdentifier: "backtoaddproductsignupfromcategorytable", sender: self)
        }
        else if fromsearchbool == "addprovider"
        {
            
            self.performSegue(withIdentifier: "backtoaddproductproviderfromcategorytable", sender: self)
        }
        else if fromsearchbool == "categoryproductlist"
        {
            self.performSegue(withIdentifier: "backtocategoryproductlistfromcategorytable", sender: self)
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterdata(searchtext:searchController.searchBar.text!)
    }
    
    
    func filterdata(searchtext: String){
        self.filtereddata = self.mycategories.filter(){nil != $0.name?.range(of: searchtext , options: .caseInsensitive)  }
        self.tableView.reloadData()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        
   
           self.searchcontroller.isActive = false
            
        
        
    }
    
    
    //********* get all categories *************
    
    
    func get_all_categories (){
        
        let request = base_api().all_categories_request()
       
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            guard let data = data , error == nil, urlresponse != nil else {
                //print ("can not download check internet")
                DispatchQueue.main.async {
                    
                    self.load.hide(animated: true)
                    self.view.isUserInteractionEnabled = true
                    
                }
                return
            }
            //  print ("downloaded")
            do
            { print(data)
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    if downloads.categories != nil {
                        self.mycategories = downloads.categories!
                        
                        DispatchQueue.main.async {
                            
                            print ("reloading")
                            
                            self.tableView.reloadData()
                            self.load.hide(animated: true)
                            self.view.isUserInteractionEnabled = true
                        }
                        
                        
                    }
                }
                else{
                    DispatchQueue.main.async {
                        
                        self.load.hide(animated: true)
                        self.view.isUserInteractionEnabled = true
                    }
                    print ( "status: "  + downloads.status!)
                    
                }
            }catch {
                DispatchQueue.main.async {
                    
                    self.load.hide(animated: true)
                    self.view.isUserInteractionEnabled = true
                }
                print ("json decoder error ")
            }
            }.resume()
        
    }
    //******************************
    
}


