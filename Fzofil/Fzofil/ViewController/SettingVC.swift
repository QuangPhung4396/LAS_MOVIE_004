import UIKit
import StoreKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionProrixy(_ sender: Any) {
        let urlStr = "https://apps.apple.com/us/developer/bac-giang-lgg-garment-corporation/id1510367588"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
    
        }
    }
    @IBAction func actionFeedback(_ sender: Any) {
        EmailService().compose(controller: self)
    }

    @IBAction func actionRate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
}
