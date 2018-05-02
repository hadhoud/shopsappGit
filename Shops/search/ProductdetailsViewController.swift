
import UIKit

class ProductdetailsViewController: UIViewController {
    
    var shopinfoproduct: product?
    
    @IBOutlet weak var shopinfoproductdetailsimage: UIImageView!
    @IBOutlet weak var shopiinfoproductdetailstitle: UILabel!
    @IBOutlet weak var shopinfoproductdetailsprice: UILabel!
    @IBOutlet weak var shopinfoproductdetailsdescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuplayout()

//global.v2.frame = CGRect(x: 0, y: 60, width:  UIApplication.shared.keyWindow!.frame.width, height: 50)
        // Do any additional setup after loading the view.
    }
    func setuplayout(){

        self.shopinfoproductdetailsimage.getlogofromurl(shopinfoproduct?.logo ?? "")
        self.shopiinfoproductdetailstitle.text = shopinfoproduct!.title ?? ""
        self.shopinfoproductdetailsprice.text = ("\(shopinfoproduct!.price ?? "0") $")
        self.shopinfoproductdetailsdescription.text = shopinfoproduct!.description ?? ""
    }
}


