# Stylish_Project
Stylish是一個電商衣飾販售的 APP，其中製作此 APP 大量使用 Swift 語言處理頁面間資料傳遞的方法，如 `Delegate Pattern` 、 `Notification Center` 與 `Singleton` 等相關概念。

![image](https://github.com/kbl26amy/Stylish_Project/blob/master/stylish_480.gif?raw=true)

一、
以下程式碼為用戶選取喜愛的商品進購物車所設計使用的 StorageManager，運用的觀念包括 `Core Data` 本地存取、 `Singleton` 與 `Error Handle`：

```Swift
import CoreData

class StorageManager {
    static let storagsharedmanager = StorageManager()
    private var buyItem: [CartProduct] = []

    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "STYLISH")
        container.loadPersistentStores(completionHandler: { (cartBuyItem, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
  ...
    
    func fetchBuyItem () {
        let managedContext =
                    StorageManager.storagsharedmanager.viewContext
        
                let fetchRequest =
                    NSFetchRequest<CartProduct>(entityName: "CartProduct")
                do {
                    buyItem = try managedContext.fetch(fetchRequest)
                    print("fetch拿到\(StorageManager.storagsharedmanager.getBuyItem().count)")
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
    }
}    
```
二、
除此之外 ，使用 FB login 作為用戶登入方式，並存在 keychain 中加密獲取 token，其中運用到 URLSession、URLRequest、https 等網路相關知識，程式碼如下：

```Swift      
                    
    URLSession.shared.dataTask(with: request, completionHandler: { (data, responce, error) in
        guard let data = data else { return }
        let decoder = JSONDecoder()
             do {
                  let loginData = try decoder.decode(FBData.self, from: data)
                           
                  DispatchQueue.main.async {
                  UIAlertController.showAlert(message:  NSLocalizedString("loginsucess", comment: ""))
                  self.keychain["stylishToken"] = loginData.data.accessToken
                          
                  self.dismiss(animated: true, completion: nil)
                            }
                            
                        } catch {
                            print(error)
                        }
                        
                    }).resume()
                   
                }
       }
    }
```
三、為了通知用戶購物車內的數量，使用了 Notification 觀察並更新 tabbar item 上的數量：

```Swift
class StyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        StorageManager.storagsharedmanager.fetchBuyItem()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidCreate), name: .didUpdateBuyItemList, object: nil)
        
        NotificationCenter.default.post(name: .didUpdateBuyItemList, object: self, userInfo: nil)
    }
    @objc func handleDidCreate(notification: Notification) {
        if StorageManager.storagsharedmanager.getBuyItem().count >= 1 {
          self.viewControllers?[2].tabBarItem.badgeValue = "\(StorageManager.storagsharedmanager.getBuyItem().count)"}
          UITabBarItem.appearance().badgeColor = . brown
    }
}
extension Notification.Name {
    static let didUpdateBuyItemList = Notification.Name("didUpdateBuyItemList")
}

```

### Third-Party Libraries
* 
* Kingfisher - 善用快取的方式處理網路圖片並呈現在 App
* IQKeyboardManager - 解決鍵盤彈起時遮住輸入框的工具
* KeychainAccess - 針對用戶 id 加密
* CRRefresh - 下拉功能套件
* ESPullToRefresh - 上滑功能套件
* Alamofire - 協助網路API流程的第三方工具
* SwiftLint - 檢查 CodingStyle 與格式的工具
* FBSDKLoginKit - 使用FB登入處理用戶註冊
     
### Requirements
-----------------
* Xcode11
* iOS 13
截圖畫面展示：
![image](https://github.com/kbl26amy/Stylish_Project/blob/master/Stylish%20Introduction.png?raw=true)

