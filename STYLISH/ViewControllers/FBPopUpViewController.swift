import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import KeychainAccess

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
                            print(loginData)
                           
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
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func cancelButton(_ sender: Any) {
    }
    
}
