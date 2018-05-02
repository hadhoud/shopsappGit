//
//  ShopinfoViewController.swift
//  collection
//
//  Created by Admin on 11/25/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit
import GoogleMaps
class ShopinfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mytableviewcell: UIView!
    @IBOutlet weak var shopinfocollection: UICollectionView!
    @IBOutlet weak var categorytitle: UILabel!
    var superindex: Int?
    var categorystring: String! {
        didSet {
            categorytitle.text = categorystring
        }
    }
    func cornerforview (){
        self.mytableviewcell.layer.cornerRadius = 20
        self.mytableviewcell.layer.masksToBounds = true
    }
    func registerCollectionview<DataSource:UICollectionViewDataSource>(datasource:DataSource){
        
        self.shopinfocollection.dataSource = datasource
        
    }
    func registerCollectionviewdelegate<Delegate:UICollectionViewDelegate>(delegate:Delegate){
        self.shopinfocollection.delegate = delegate
        
    }
    func reload()
    {
        self.shopinfocollection.reloadData()
    }
}

class ShopinfCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var shopinfoproductimage: UIImageView!
    @IBOutlet weak var productname: UILabel!
}

class ShopinfoViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    @IBAction func infos(_ sender: Any) {
        performSegue(withIdentifier: "toshopinformationfromshop", sender: self)
    }
    @IBOutlet weak var shopinfoshoplogo: UIImageView!
    @IBOutlet weak var shopinfoshopname: UILabel!
    @IBOutlet weak var mytableview: UITableView!
    
    // var shopinfo: myuserinfo?
    var shopinfo: [userinfo]?
    var shopinfoproductself: product?
    var providerarray: [category]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // UIApplication.shared.keyWindow!.addSubview(global.v2)
        mytableview.dataSource = self
        
        fillshopddata()
    }
    func fillshopddata(){
       
        self.shopinfoshopname.text = shopinfo![0].shopName ?? ""
        self.shopinfoshoplogo.getlogofromurl(shopinfo![0].logo ?? "")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        providerarray = shopinfo![0].lstCategories!
        // remove category with  no product
        for (index , e) in providerarray.enumerated().reversed(){
            
            if e.lstProducts?.count == 0
            {
                
                providerarray.remove(at: index)
            }
        }
        return providerarray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopinfoTableViewCell", for: indexPath) as! ShopinfoTableViewCell
        
        cell.registerCollectionview(datasource: self)
        cell.registerCollectionviewdelegate(delegate: self)
        cell.cornerforview()
        cell.categorystring = providerarray[indexPath.row].name ?? ""
        cell.selectionStyle = .none
        
        cell.shopinfocollection.tag = indexPath.row
        cell.reload()
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  providerarray[collectionView.tag].lstProducts!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopinfCollectionViewCell", for: indexPath) as! ShopinfCollectionViewCell
        // product title
        cell.productname.text = providerarray[collectionView.tag].lstProducts![indexPath.row].title ?? ""
        //product image
        cell.shopinfoproductimage.getlogofromurl(providerarray[collectionView.tag].lstProducts![indexPath.row].logo ?? "")
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // open product details when cell in shopdetails is selected
        shopinfoproductself = providerarray[collectionView.tag].lstProducts![indexPath.row]
        self.performSegue(withIdentifier: "toproductdetails", sender: self)
    }
   
    
    // to send data to shop details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProductdetailsViewController {
            destination.shopinfoproduct = shopinfoproductself
        }
        if let destination = segue.destination as? shopdetailsViewController {
            destination.info = shopinfo
        }
        if let destination = segue.destination as? ShopmapViewController {
            
            destination.shoplocation = CLLocation(latitude: self.shopinfo![0].latitude!, longitude: self.shopinfo![0].longitude!)
            
            
        }
    }
    
}

