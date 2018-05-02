
import UIKit

class base_api {
   
   let base_url = "http://213.175.200.32:8080"
  //  let base_url = "http://192.168.17.1"
    
    var defaultimage: UIImage = #imageLiteral(resourceName: "noImage")
    func search_by_product () -> String {return "search_by_product"}
    func search_by_category () -> String {return "search_by_category"}
    func search_by_intelligentsearch () -> String {return "search_by_description"}
    
    func search_request(type : String , latitude : Double  , longitude : Double ,  searchname : String , distance : Int , isNearYou : Int) -> URLRequest{
        var url : URL
        var jsondata : [String : Any]
        switch type {
        case base_api().search_by_category():
            jsondata = [ "latitude": latitude , "longitude" : longitude , "categoryName" : searchname , "distance" : distance  ,  "isNearYou": isNearYou]
            url = URL(string: "\(base_url)/Shops/shops/categories/search_by_category")!
            break
        case base_api().search_by_intelligentsearch():
            jsondata = [ "latitude": latitude , "longitude" : longitude ,"description": searchname , "distance" : distance  ,  "isNearYou": isNearYou]
            url = URL(string: "\(base_url)/Shops/shops/products/search_by_description")!
            break
        case base_api().search_by_product():
            jsondata = ["latitude": latitude , "longitude" : longitude , "productName":searchname , "distance" : distance  ,  "isNearYou": isNearYou]
            url = URL(string: "\(base_url)/Shops/shops/products/search_by_product")!
            //url = URL(string:"http://192.168.17.1/data.php")!
            break
        default:
            jsondata = ["string":"string"]
            url = URL(string: "\(base_url)/Shops/shops/products/search_by_product")!
        }
        let json = try? JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
        //printstring(data: json!)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!
        return request
    }
    func register_request(data : registration) -> URLRequest{
        
        var json = Data()
        let  url = URL(string: "\(base_url)/Shops/shops/user/register")!
        do {
            json = try JSONEncoder().encode(data)
            
        }
        catch(_){
            print ("error request\n")
        }
        
       
       // printstring(data: json)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        return request
    }
    func save_category(data : category_save) -> URLRequest{
        
        var json = Data()
        let  url = URL(string: "\(base_url)/Shops/shops/categories/save")!
        do {
            json = try JSONEncoder().encode(data)
            
        }
        catch(_){
            print ("error request\n")
        }
        
       //  printstring(data: json)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        return request
    }
    func saveproduct(data : product_save ) -> URLRequest{
        
        var json = Data()
        let  url = URL(string: "\(base_url)/Shops/shops/products/save")!
        do {
            json = try JSONEncoder().encode(data)
            
        }
        catch(_){
            print ("error request\n")
        }
        
       // printstring(data: json)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        return request
    }
    func login_request (username : String , password : String) -> URLRequest{
        let  jsondata = ["userName":username , "password" : password]
        let url = URL(string :"\(base_url)/Shops/shops/user/login")
        let json = try? JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
        // printstring(data: json!)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!
        return request
    }
    func get_info_request(token : String , include_non_approved_categories : Int)->URLRequest{
        let  jsondata = ["auth_token":token , "include_non_approved_categories" : include_non_approved_categories] as [String : Any]
        
        let url = URL(string :"\(base_url)/Shops/shops/user/get_user_info")
        let json = try? JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
       // printstring(data: json!)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!
        return request
    }
    func ads_user_info(userName : String )->URLRequest{
        let  jsondata = ["userName":userName] as [String : Any]
        
        let url = URL(string :"\(base_url)/Shops/shops/user/get_user_by_name")
        let json = try? JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
        // printstring(data: json!)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!
        return request
    }
    func valid_username_request(username: String) -> URLRequest {
        let  jsondata = ["userName":username]
        let url = URL(string :"\(base_url)/Shops/shops/user/username_is_valid")
        let json = try? JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
        // printstring(data: json!)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!
        return request
    }
    func valid_shopname_request(shopName: String) -> URLRequest {
        let  jsondata = ["shopName":shopName]
        let url = URL(string :"\(base_url)/Shops/shops/user/shopname_is_valid")
        let json = try? JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
        //printstring(data: json!)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!
        return request
    }
    func all_categories_request() -> URLRequest {
        
        let url = URL(string :"\(base_url)/Shops/shops/categories/all")
     
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "GET"
       
        return request
    }
    func all_ads_request() -> URLRequest {
        
        let url = URL(string :"\(base_url)/Shops/shops/advertisements/all")
        
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "GET"
        
        return request
    }
    func get_password(email: String) -> URLRequest {
        let  jsondata = ["email": email]
        let url = URL(string :"\(base_url)/Shops/shops/user/forgot_password")
        let json = try? JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
        // printstring(data: json!)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!
        return request
    }
    func printstring(data : Data)  {
        let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("*****This is the data : \(String(describing: dataString!))")
    }
    // DATA  geters
    func load (key : String)->String {
        
        let x =  UserDefaults.standard.string(forKey: key) ?? ""
        return x
        
    }
    // DATA setters
    func save(key : String , value : Any){
        
        UserDefaults.standard.set(value, forKey: key )
        
    }
    
    
    func getimagebase64(image : UIImage)->String{
        
        let imageString = String(describing:NSString(data: (UIImageJPEGRepresentation(image,0.0)!.base64EncodedData()), encoding: String.Encoding.utf8.rawValue)!)
        return imageString
    }

    func toarrayofbyte(image : UIImage)-> [Int8] {
        let imagedata =  UIImageJPEGRepresentation(image,0.0)
        let arrayofbyteuint8 : [UInt8] = Array(imagedata!)
         let arrayofbyte = arrayofbyteuint8.map {Int8 (bitPattern: $0)}

     
        return arrayofbyte
    }
    
}
let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {

    func getlogofrombytearray(byteint8: [Int8]) {

         let arr3b = byteint8.map {UInt8 (bitPattern: $0)}

        let data = Data(bytes: arr3b)
        DispatchQueue.main.async {
            self.image = UIImage(data: data)!
        }
    }
    func getlogofromurl(_ urlString: String) {
        
        self.image = base_api().defaultimage
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
        
            return
        }
  
        guard let imageurl = URL(string: urlString) else { return }
        

       DispatchQueue.global(qos: .userInitiated).async {
        let data = try? Data(contentsOf: imageurl)
        if let data = data {
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
      imageCache.setObject(downloadedImage, forKey: urlString as NSString)

       self.image = downloadedImage
                                }
                            }
        }
            
            
        }
    }
}


extension UIViewController {
    
    
    
    // ***************************Toast function *************************
    
    func showToast(message : String) {
        
        let fontAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18 )]
        let sizeOfString = (message as NSString).size(withAttributes: fontAttributes)
        
        
       let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - (sizeOfString.width + 20 )/2 , y:self.view.frame.size.height - 150 , width: sizeOfString.width + 20 , height: 30))
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
     toastLabel.font = UIFont.systemFont(ofSize: 18)
      //  toastLabel.font = UIFont(name: "Montserrat-Light", size: 14.0)
        toastLabel.alpha = 0.9
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5, delay: 0.1, options: .curveEaseInOut , animations: {
            toastLabel.alpha = 0.0 }, completion: {
                (isCompleted) in toastLabel.removeFromSuperview()
                
        })
    }
}

extension UITableViewController {
    
    
    
    // ***************************Toast function *************************
    
    func showToasttable(message : String) {
        
        let fontAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18 )]
        let sizeOfString = (message as NSString).size(withAttributes: fontAttributes)
        
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - (sizeOfString.width + 20 )/2 , y:self.view.frame.size.height - 170 , width: sizeOfString.width + 20 , height: 30))
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 18)
        //  toastLabel.font = UIFont(name: "Montserrat-Light", size: 14.0)
        toastLabel.alpha = 0.9
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5, delay: 0.1, options: .curveEaseInOut , animations: {
            toastLabel.alpha = 0.0 }, completion: {
                (isCompleted) in toastLabel.removeFromSuperview()
                
        })
    }
}
