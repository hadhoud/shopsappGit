

import UIKit
import CoreLocation
class MainViewController: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var searchtext: hhstextfield!
    @IBOutlet weak var distancetext: UITextField!
    @IBOutlet weak var sliderdistance: UISlider!
    var locationManager = CLLocationManager()
    var canaccessmylocation: Bool = false
    var type : String = base_api().search_by_product()
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var shops = [userinfo]()
    var load = MBProgressHUD()
    
    
    // did load function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addobservers()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        self.searchtext.delegate = self
         base_api().save(key: "token", value: "")
     //   let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
       // self.segment.setTitleTextAttributes(titleTextAttributes, for: .normal)
     //   self.segment.setTitleTextAttributes(titleTextAttributes, for: .selected)
      //  self.segment.layer.borderWidth = 2
       // self.segment.layer.borderColor = UIColor.init(red: 84/255, green: 47/255, blue: 82/255, alpha: 1.0).cgColor
      //  self.segment.layer.cornerRadius = 5
        //self.segment.layer.masksToBounds = true
    }
    
    
    @IBAction func sliderchangevalue(_ sender: UISlider) {
        if sender.value >= 1000 {
            // get value in Kilometer
            let takedvalue = Float(sender.value)/1000
            let text = String(format: "%.2f", takedvalue)
            self.distancetext.text = text+" Km"
        }
        else if sender.value < 1000 {
            //get value in meter
            let takedvalue = Float(sender.value)
            let text = String(format: "%.2f", takedvalue)
            self.distancetext.text = text+" M"
        }
    }
    
    @IBAction func segmentclick(_ sender: UISegmentedControl) {
        //search by product
        // let usernameattributes = [NSAttributedStringKey.foregroundColor: UIColor.lightText , NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        if sender.selectedSegmentIndex == 0{
            self.searchtext.text = ""
            self.searchtext.iscategorybool = false
            type = base_api().search_by_product()
            self.searchtext.imag = nil
            self.searchtext.overlaybutton.removeTarget(self, action: #selector(self.categoryclicked), for: .touchUpInside)
           
            self.searchtext.placeholder = "Name Of Product"
        }
            //search by description
        else if sender.selectedSegmentIndex == 1{
            self.searchtext.text = ""
            self.searchtext.iscategorybool = false
            self.searchtext.imag = nil
            type = base_api().search_by_intelligentsearch()
            self.searchtext.overlaybutton.removeTarget(self, action: #selector(self.categoryclicked), for: .touchUpInside)
            self.searchtext.placeholder = "Description"
        }
            // search by category
        else if sender.selectedSegmentIndex == 2{
            self.searchtext.text = ""
            self.searchtext.iscategorybool = true
            self.searchtext.imag = #imageLiteral(resourceName: "getcategorygreen")
            self.searchtext.overlaybutton.addTarget(self, action: #selector(self.categoryclicked), for: .touchUpInside)
            self.searchtext.placeholder = "Choose a Category"
            type = base_api().search_by_category()
        }
    }
    @objc func categoryclicked(){
        performSegue(withIdentifier: "tocategoryfromsearch", sender: self)
    }
    
    // button search click
    @IBAction func searchclick(_ sender: Any) {
        view.endEditing(true)
        // get if search by category to change image
        if self.segment.selectedSegmentIndex == 2{
            self.searchtext.iscategorybool = true
        }
        else {
            self.searchtext.iscategorybool = false
        }
        
        //start get location
        
        locationManager.startUpdatingLocation()
        // check location access
        if canaccessmylocation {
            searchtext.checknoempty()
            if searchtext.noemptybool {
                // json for search
                load = MBProgressHUD.showAdded(to: self.view, animated: true)
                load.mode = .indeterminate
                load.label.text = "loading"
                self.view.isUserInteractionEnabled = false
                search(type: type, latitude: latitude, longitude: longitude, searchname: self.searchtext.text ?? "", distance: Int(self.sliderdistance.value) * 10)
                
                //     self.performSegue(withIdentifier: "toshoplist", sender: self )
            }
        }
        else
        {
            // alert if no access to location
            let alert = UIAlertController(title: "No Location Access", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancel = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
            
            let gotosetting = UIAlertAction.init(title: "Go To Settings", style: .default, handler: { (alert: UIAlertAction!) in
                
                // check if ios 10 and newer
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                }
            })
            alert.addAction(gotosetting)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    //return textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addobservers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeobservers()
    }
    
    // hide keyboard when view clicked
    @IBAction func viewpressed(_ sender: Any) {
        view.endEditing(true)
    }
    // add observers
    fileprivate func addobservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardshow), name: .UIKeyboardWillShow , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhide), name: .UIKeyboardWillHide , object: nil)
        
    }
    
    // remove observers
    func removeobservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    //hide keyboard
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
                self.view.frame = CGRect.init(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
                
        }, completion: nil)
    }
    
    
    func search (type : String , latitude : Double  , longitude : Double ,  searchname : String , distance : Int ){
        
        let decoder = JSONDecoder()
        let request = base_api().search_request(type: type, latitude: latitude, longitude: longitude, searchname: searchname, distance: distance)
        
        // start Session
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            guard let data = data , error == nil,urlresponse != nil else {
                print ("can not download check internet")
                DispatchQueue.main.async {
                    self.load.hide(animated: true)
                    self.view.isUserInteractionEnabled = true
                    self.showToast(message: "No Internet")
                    
                }
                return
            }
            print ("downloaded")
            print (data)
            do
            {
                
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    
                    do {
                        if (downloads.shops != nil){
                            self.shops = downloads.shops!
                            DispatchQueue.main.async {
                                
                                self.load.hide(animated: true)
                                self.view.isUserInteractionEnabled = true
                                self.performSegue(withIdentifier: "toshoplist", sender: self )
                            }}
                        else {
                            DispatchQueue.main.async {
                                self.showToast(message: "No Results Found")
                                self.load.hide(animated: true)
                                self.view.isUserInteractionEnabled = true
                                
                            }
                        }
                    }
                }
                else{
                    
                    
                    DispatchQueue.main.async {
                        print ( "status: "  + downloads.status!)
                        self.load.hide(animated: true)
                        self.view.isUserInteractionEnabled = true
                    }
                    
                }
            }catch {
                print ("json decoder error ")
                DispatchQueue.main.async {
                    self.load.hide(animated: true)
                    self.view.isUserInteractionEnabled = true
                }
            }
            }.resume()
    }
    
    // prepare for multiple segue from search
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "tocategoryfromsearch" :
            if let destination = segue.destination as? CategoryTableViewController {
                destination.fromsearchbool = "search"
            }
        case "toshoplist" :
            if let destination = segue.destination as? ShoplistTableViewController {
                
                destination.myuserinfoases = self.shops
            }
        default:
            break
        }
    }
    @IBAction func unwindfromcategorytabletosearch(sender: UIStoryboardSegue)
    {
        if sender.source is CategoryTableViewController {
            if let getcategory = sender.source as? CategoryTableViewController {
                self.searchtext.text = getcategory.categorychoosed
            }
        }
        
    }
    
    //location manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let myl = locations.last else {return}
        self.latitude = Double(myl.coordinate.latitude)
        self.longitude = Double(myl.coordinate.longitude)
        print (latitude)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            canaccessmylocation = false
        case .denied:
            canaccessmylocation = false
            print("User denied access to location.")
        case .notDetermined:
            canaccessmylocation = false
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK")
            canaccessmylocation = true
        }
    }
    
}


