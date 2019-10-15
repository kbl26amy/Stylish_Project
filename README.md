# Stylish_Project
Stylish是一個電商衣飾販售的 APP，其中製作此 APP 大量使用 Swift 語言處理頁面間資料傳遞的方法，如 delegate Pattern 、 Notification 與 Singleton 等相關概念。

一、
以下程式碼為用戶選取喜愛的商品進購物車所設計使用的 StorageManager，運用的觀念包括 Core Data 本地存取、 Singleton 與 Error Handle：

```
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
        var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func removeBuyItem (position: Int) {
        self.buyItem.remove(at: position)
    }
    
    func getBuyItem() -> [CartProduct] {
        return self.buyItem
    }
    
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
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
```
二、
除此之外 ，使用 FB login 作為用戶登入方式，並存在 keychain 中加密獲取 token，其中運用到 URLSession、URLRequest、https 等網路相關知識，程式碼如下：

```
class FBPopUpViewController: UIViewController {
  
    let keychain = Keychain()
 
    @IBAction func FBloginButtonAction(_ sender: UIButton) {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: [ .publicProfile, .email ], viewController: self) { loginResult in
              
              switch loginResult {
              
                case .failed(let error):
                    print(error)
                case .cancelled:
                    UIAlertController.showAlert(message: NSLocalizedString("loginfail", comment: ""))
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("Logged in!")
                    
                    let accessToken = accessToken.tokenString        
                    var request = URLRequest(url: URL(string: "https://api.appworks-school.tw/api/1.0/user/signin")!)
                    
                    request.httpMethod = "POST"
                    request.allHTTPHeaderFields = ["Content-Type": "application/json"]
                    
                    let body = ["provider": "facebook", "access_token": (accessToken)]
                    let data = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                    request.httpBody = data         
                    
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

```
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
其他功能與畫面展示：
![image](https://github.com/kbl26amy/Stylish_Project/blob/master/Stylish%20Introduction.png?raw=true)

