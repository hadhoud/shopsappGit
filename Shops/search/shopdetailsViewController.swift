

import UIKit

class shopdetailsViewController: UIViewController {
    
    var info : [userinfo]? = []
    
    @IBOutlet var shop_image: UIImageView!
    @IBOutlet var shop_name: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var mobile: UILabel!
    @IBOutlet var whatsapp: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var website: UILabel!
    @IBOutlet var descriptions: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loaddata()
    }

    func loaddata (){
      
        self.shop_image.getlogofromurl(info![0].logo ?? "")
        shop_name.text = info![0].shopName ?? ""
        address.text = info![0].address ?? ""
        mobile.text = info![0].mobile ?? ""
        whatsapp.text = info![0].whatsapp ?? ""
        email.text = info![0].email ?? ""
        phone.text = info![0].phone ?? ""
        website.text = info![0].website ?? ""
        descriptions.text = info![0].generalDescription ?? ""
    }



}
