
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
class SignupfirstViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , CLLocationManagerDelegate , UITextFieldDelegate , GMSMapViewDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var shopname: hhstextfield!
    @IBOutlet weak var signupusername: hhstextfield!
    @IBOutlet weak var signuppassword: hhstextfield!
    @IBOutlet weak var signupconfirmpassword: hhstextfield!
    @IBOutlet weak var Signupshoplogo: UIImageView!
   // @IBOutlet weak var signuplocation: hhstextfield!
    @IBOutlet weak var shopmapview: GMSMapView!
    @IBOutlet weak var alert: UILabel!
    
    var mapView : GMSMapView!
    var valid_username : Bool = false
    var valid_shopname : Bool = false
    let default_image = #imageLiteral(resourceName: "truegreen")
    var longitude: Double = 0.0
    var lattitude: Double = 0.0
    var imageischanged : Bool = false
    var locationmanager = CLLocationManager()
    var canaccessmylocationignup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shopmapview.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
       
        addobservers()
        self.shopname.delegate = self
        self.signupusername.delegate = self
        self.signuppassword.delegate = self
        self.signupconfirmpassword.delegate = self
        self.locationmanager.startUpdatingLocation()
        self.shopmapview.isMyLocationEnabled = true
        self.shopmapview.settings.scrollGestures = false
        self.shopmapview.settings.zoomGestures = false
        
    }
    
    
    
    @IBAction func shopnamechangeediting(_ sender: Any) {
        
        self.shopname.checknoempty()
        
        if (shopname.text?.isEmpty)! || (shopname.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
        }
        else {
            checkshopname(shopname: shopname.text ?? "")
        }
        
    }
    
    @IBAction func shopusernameeditingchange(_ sender: Any) {
        self.signupusername.checknoempty()
        
        if (signupusername.text?.isEmpty)! || (signupusername.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            
        }
        else {
            checkusers(username: signupusername.text ?? "" )
        }
        
    }
    
    func checkpassandconf(){
        if (signupconfirmpassword.text == signuppassword.text)  {
            signupconfirmpassword.imag = #imageLiteral(resourceName: "truegreen")
            signupconfirmpassword.noemptybool = true
            signuppassword.noemptybool = true
        }
        else
        {
            signupconfirmpassword.imag = #imageLiteral(resourceName: "falsered")
            signupconfirmpassword.noemptybool = false
            signuppassword.noemptybool = false
        }
    }
    @IBAction func passwordeditingchange(_ sender: hhstextfield) {
        checkpassandconf()
    }
    @IBAction func confirmpasswordeditingchange(_ sender: Any) {
        checkpassandconf()
    }
    
    @IBAction func signupfirstnextclick(_ sender: UIBarButtonItem) {
        
        // get location again
       // self.locationmanager.startUpdatingLocation()
        // check if has access location
        if canaccessmylocationignup {
            // fill location text
        //    self.signuplocation.text = String(self.lattitude)+"/" + String(self.longitude)
            if imageischanged {
                if shopname.noemptybool && signupusername.noemptybool && signuppassword.noemptybool && signupconfirmpassword.noemptybool
            {
                //print (datatosend())
                performSegue(withIdentifier: "tosignupcontact", sender: self)
            }
                else {
            self.showToast(message: "Please Fill All Fields")
                }
            }
            else {
                 self.showToast(message: "Please Choose A Logo")
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
    //click on view hide keyboard
    
    @IBAction func viewclickedforkeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    //add observers for keyboard
    fileprivate func addobservers(){
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: {notification in self.keyboardshow(notification: notification)})
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: {notification in self.keyboardhide(notification: notification)})
    }
    
    // remove observers
    func removeobservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //hide keyboard
    func keyboardhide(notification: Notification){
        scrollview.contentInset = UIEdgeInsets.zero
    }
    
    //show keyboard scrolling
    func keyboardshow(notification: Notification){
        guard let userinfo = notification.userInfo , let frame = (userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentinset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height - 20 , right: 0)
        scrollview.contentInset = contentinset
    }
    
    
    // choose shop logo
    
    @IBAction func signuplogoclicked(_ sender: UITapGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.Signupshoplogo.image = image
            imageischanged = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //location manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationmanager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let myl = locations.last else {return}
        self.lattitude = Double(myl.coordinate.latitude)
        self.longitude = Double(myl.coordinate.longitude)
      //  self.signuplocation.text = String(self.lattitude)+"/" + String(self.longitude)
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude , longitude: longitude , zoom: 12.0)
        shopmapview.camera = camera
        let colorred = UIColor.green
         self.shopmapview.clear()
        createMarker( titleMarker: "My Location", latitude: lattitude, longitude: longitude , color: colorred )
   //     self.locationmanager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            //    print("Location access was restricted.")
            canaccessmylocationignup = false
            self.alert.text = "Enable Location Services"
        case .denied:
            canaccessmylocationignup = false
             self.alert.text = "Enable Location Services"
        //  print("User denied access to location.")
        case .notDetermined:
            canaccessmylocationignup = false
             self.alert.text = "Enable Location Services"
        //  print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            //   print("Location status is OK")
            canaccessmylocationignup = true
             self.alert.text = "Your Shop Location"
        }
    }
    // create marker in map 
    func createMarker(titleMarker: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees , color:UIColor) {
        
        let marker = GMSMarker()
       
        marker.map = nil
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.appearAnimation = .pop
        marker.icon = GMSMarker.markerImage(with: color)
        marker.map = self.shopmapview
    }
    //**********************   json classes************
    
    //  ******************* user check ************* cheked 100 % ******
    
    func checkusers (username : String){
        
        URLSession.shared.dataTask(with: base_api().valid_username_request(username: username)) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            guard let data = data , error == nil, urlresponse != nil else {
                //                self.valid_username = false
                //                self.signupusername.imag = #imageLiteral(resourceName: "falsered")
                //                self.signupusername.noemptybool = false
                return
            }
            
            do
            { print(data)
                let downloads = try decoder.decode(Res_data.self, from: data)
                if downloads.status == "OK" {
                    DispatchQueue.main.async {
                        if self.signupusername.noemptybool{
                            //change something its valid
                            self.valid_username = true
                            self.signupusername.imag = #imageLiteral(resourceName: "truegreen")
                            self.signupusername.noemptybool = true
                        }}
                }
                else if downloads.status == "USERNAME_ALREADY_EXISTS"{
                    DispatchQueue.main.async {
                        
                        //change something usename exists
                        self.valid_username = false
                        self.signupusername.imag = #imageLiteral(resourceName: "falsered")
                        self.signupusername.noemptybool = false
                    }
                }
                else{
                    DispatchQueue.main.async {
                        //change something usename exists
                        self.valid_username = false
                        self.signupusername.imag = #imageLiteral(resourceName: "falsered")
                        self.signupusername.noemptybool = false
                    }
                }
            }catch {
                print ("json decoder error ")
            }
            }.resume()
        
    }
    
    // ************************************** end of check ******************************
    
    //  ******************* shopname check ************* cheked 100 % ******
    
    func checkshopname (shopname : String){
        
        URLSession.shared.dataTask(with: base_api().valid_shopname_request(shopName: shopname)) { (data, urlresponse, error) in
            let decoder = JSONDecoder()
            guard let data = data , error == nil, urlresponse != nil else {
                //                self.valid_shopname = false
                //                self.shopname.imag = #imageLiteral(resourceName: "falsered")
                //                self.shopname.noemptybool = false
                return
            }
            print ("downloaded")
            do
            { print(data)
                let downloads = try decoder.decode(Res_data.self, from: data)
                if downloads.status == "OK" {
                    DispatchQueue.main.async {
                        //change something its valid
                        if self.shopname.noemptybool{
                            self.valid_shopname = true
                            self.shopname.imag = #imageLiteral(resourceName: "truegreen")
                            self.shopname.noemptybool = true
                            
                        }}
                }
                else if downloads.status == "SHOPNAME_ALREADY_EXISTS"{
                    DispatchQueue.main.async {
                        //change something shopname exists
                        self.valid_shopname = false
                        self.shopname.imag = #imageLiteral(resourceName: "falsered")
                        self.shopname.noemptybool = false
                    }
                }
                else{
                    DispatchQueue.main.async {
                        //change something shopname exists
                        self.valid_shopname = false
                        self.shopname.imag = #imageLiteral(resourceName: "falsered")
                        self.shopname.noemptybool = false
                    }
                }
            }catch {
                print ("json decoder error ")
            }
            }.resume()
        
    }
    
    // ************************************** end of check ******************************
    @IBAction func sigupfirstunwindsegue(unwindSegue: UIStoryboardSegue)
    {
        
    }
    
    //******************** append data array ***********************
    
    func datatosend()->[String : String ]{
        return (["shopName" : shopname.text ?? "" ,"userName" : signupusername.text ?? "" , "password" : signuppassword.text ?? ""])
        
    }
    //********************************* segue ***************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SignupcontactViewController {
            destination.datafromfirst = datatosend()
            destination.location = ["latitude" : lattitude , "longitude" : longitude]
            destination.logofromfirst = base_api().toarrayofbyte(image: Signupshoplogo.image ?? #imageLiteral(resourceName: "noImage"))
        }
    }
    
    
    // end of class
}

