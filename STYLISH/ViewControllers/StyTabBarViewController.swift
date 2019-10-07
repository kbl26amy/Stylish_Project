import UIKit
import CoreData

class StyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
           StorageManager.storagsharedmanager.fetchBuyItem()
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleDidCreate), name: .didUpdateBuyItemList, object: nil)
        print("observer")
        
        NotificationCenter.default.post(name: .didUpdateBuyItemList, object: self, userInfo: nil)
        print("post")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.tabBar.isHidden = false
    }
    @objc func handleDidCreate(notification: Notification) {
        if StorageManager.storagsharedmanager.getBuyItem().count >= 1 {
            self.viewControllers?[2].tabBarItem.badgeValue = "\(StorageManager.storagsharedmanager.getBuyItem().count)"}
        print("===================\(StorageManager.storagsharedmanager.getBuyItem().count)")
        UITabBarItem.appearance().badgeColor = . brown
    }
}
extension Notification.Name {
    static let didUpdateBuyItemList = Notification.Name("didUpdateBuyItemList")
}

/*
 
 1. Notification Name
 
 extension Notification.Name {
    static let didUpdateBuyItemList = Notification.Name("didUpdateBuyItemList")
 }
 
 2. Notification Center Register which Notification you are intresting
 
 NotificationCenter.default.addObserver(self, selector:  #selector(handleDidCreate),
 name: .didUpdateBuyItemList, object: nil)
 
 3. Notification Center post Notification
 
 NotificationCenter.default.post(name: .didUpdateBuyItemList, object: self, userInfo: nil)
 
 */
