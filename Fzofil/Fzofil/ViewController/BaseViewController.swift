import Foundation
import UIKit
import Kingfisher
import AVFoundation
class BaseViewController: UIViewController {
    
    private let overlayView = UIView()
    
    var loadingView: LoadingView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlayView()
    }
    func delay(seconds: Double,completion: (() -> Void)!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            completion()
        }
    }
    
    private func setupOverlayView() {
         loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: ActivityEx.screenWidth(), height: ActivityEx.screenHeight()))
        loadingView.tag = 100
       
      
    }
    func showLoading() {
        self.view.addSubview(loadingView)
        loadingView.animationView.play()
    }
    
    func hideLoading() {
        loadingView.animationView.stop()
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
       
}
