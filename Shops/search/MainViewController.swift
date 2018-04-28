

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
    var isNearYou : Int = 0 //replace with segment value

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
      
        
        get_all_Ads ()
       
   //  display_Ads()
        
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
        let request = base_api().search_request(type: type, latitude: latitude, longitude: longitude, searchname: searchname, distance: distance, isNearYou: isNearYou)
        
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
    
    
    /// new stuff   // timer and ADs
       var image_array = [UIImage]()
 
    var adTimer :Timer!
    var v2 : UIImageView!
    var ad_array = [ads]()
var ad_time = 1// default time
    @objc func get_all_Ads (){
        
        let request = base_api().all_ads_request()
        
        URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            guard let data = data , error == nil, urlresponse != nil else {
                print ("can not download check internet")
                DispatchQueue.main.async {
                
                }
                return
            }
             print ("downloaded")
            do
            { print(data)
                let downloads = try decoder.decode(Res_data.self, from: data)
                
                if downloads.status == "OK" {
                    if downloads.advertisements != nil {
                      print (downloads.advertisements!)
                        DispatchQueue.main.async {
                            self.ad_array = downloads.advertisements!
                            print ("Successfully loaded")
                       self.display_Ads()
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        
                    }
                    print ( "status: "  + downloads.status!)
                    
                }
            }catch {
                DispatchQueue.main.async {
                }
                print ("json decoder error ")
            }
            }.resume()
        
    }
 
    func display_Ads(){
       
        let window = UIApplication.shared.keyWindow!
     //   v2 = UIView(frame: CGRect(x: 0, y: 690, width:  window.frame.width, height: 40))
       v2 = UIImageView(frame: CGRect(x: 0, y: 680, width:  window.frame.width, height: 50))
        //v2.backgroundColor = UIColor.gray
       //v2.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Logo"))
      v2.image = #imageLiteral(resourceName: "Logo")
        window.addSubview(v2)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(Ad_click(sender:)))
        v2.isUserInteractionEnabled = true
        v2.addGestureRecognizer(gesture)
          get_ads_image()
  
    }
    @objc func Ad_click(sender : UITapGestureRecognizer) {
       
        print ("Ad Clicked")
  
        //this removes Ads
      // remove_Ads()
       
    }
    
    func remove_Ads (){
         adTimer.invalidate()
         v2.removeFromSuperview()
    }
  var index = 0
    @objc func run_Ads (){
      
      
        print ("new Ad displayed" )
        if (adTimer != nil){
            adTimer.invalidate()
            
        }
        adTimer  = Timer.scheduledTimer(timeInterval: TimeInterval(ad_time), target: self, selector: #selector(run_Ads), userInfo: nil, repeats: true)
        if (index >= image_array.count){
            index = 0
        }
     
        //v2.backgroundColor = UIColor(patternImage: image_array[index])
        v2.image = image_array[index]
        ad_time = ad_array[index].timer ?? 2
       
          index = index + 1
    }
 
    
    func get_ads_image(){
        image_array.removeAll()
        DispatchQueue.global(qos: .userInitiated).async {
         var index = 0
        
        print ("printing images")
               
        for x in self.ad_array {
            
            print (x.image ?? "bad photo")
            
            //check cache for image first
            if let cachedImage = imageCache.object(forKey: x.image! as NSString) as? UIImage {
                //self.image = cachedImage
              //  self.v2.backgroundColor = UIColor(patternImage: cachedImage)
                self.v2.image = cachedImage
                self.image_array.append(cachedImage)
                return
            }
            
            guard let imageurl = URL(string: x.image!) else { return }

            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: imageurl)
                if let data = data {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: x.image! as NSString)
                           self.v2.image = downloadedImage
                            // self.v2.backgroundColor = UIColor(patternImage: downloadedImage)
                      self.image_array.append(downloadedImage)
                       self.run_Ads()
                        }
                    }
                }
                
                }
              index = index + 1
                }
             print ("index = \(index)")
            
        }
       
    }
   
}


