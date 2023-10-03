import UIKit

class MainController: UITabBarController , UITabBarControllerDelegate {
    let unSelectColor = 0xD8D8D8
    let selectColor = 0x6F52FF
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
       
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    private func resizeImage(name: String, color: UIColor, width: Int, height: Int) -> UIImage {
        // Tạo một UIImage với kích thước mới
        let originalImage = UIImage(named: name)
        let resizedImage = originalImage?.resized(to: CGSize(width: width, height: height))
        if #available(iOS 13.0, *) {
            let selectedImage = resizedImage?.withTintColor(color).withRenderingMode(.alwaysOriginal)
            return selectedImage!

        } else {
            return resizedImage!
        }
    }

    func initView(){
        let item1 = UITabBarItem(title: "", image: resizeImage(name: "ic_bottom_1", color: UIColor(hex: unSelectColor), width: 22, height: 30), selectedImage: resizeImage(name: "ic_bottom_1", color: UIColor(hex: selectColor), width: 22, height: 30))
        let item2 = UITabBarItem(title: "", image: resizeImage(name: "ic_bottom_2", color: UIColor(hex: unSelectColor), width: 27, height: 30), selectedImage: resizeImage(name: "ic_bottom_2", color: UIColor(hex: selectColor), width: 27, height: 30))
        let item3 = UITabBarItem(title: "", image: resizeImage(name: "ic_bottom_3", color: UIColor(hex: unSelectColor), width: 30, height: 30), selectedImage: resizeImage(name: "ic_bottom_3", color: UIColor(hex: selectColor), width: 30, height: 30))
        let item4 = UITabBarItem(title: "", image: resizeImage(name: "ic_bottom_4", color: UIColor(hex: unSelectColor), width: 30, height: 30), selectedImage: resizeImage(name: "ic_bottom_4", color: UIColor(hex: selectColor), width: 30, height: 30))
        
   
        let moveVC = MoveDiaryVC()
        moveVC.tabBarItem = item1
        let myDiaryVC = MyDiaryVC()
        myDiaryVC.tabBarItem = item2
        let staticVC = StatisticsVC()
        staticVC.tabBarItem = item3
        let settingVC = SettingVC()
        settingVC.tabBarItem = item4
        
        self.viewControllers = [moveVC, myDiaryVC,staticVC, settingVC]
        self.delegate = self
        self.selectedIndex = 0
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: 0xFFFFFF)
            tabBar.standardAppearance = appearance
        }
            
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        } else {
            // Fallback on earlier versions
        }
    }

}
