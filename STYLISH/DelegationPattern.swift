import UIKit
import Foundation
import Kingfisher
import Alamofire

protocol MarketManagerDelegate: AnyObject {

    //辨認 manager 確認使用的內容
    func manager(_ manager: MarketManager, didGet marketingHots: [Product])
    func manager(_ manager: MarketManager, didFailWith error: Error)
    
    //勁量避免設計有 optional 的參數型別，將判斷寫在 model 裡
    func otherManager(_ manager: MarketManager, didGet marketingHots: [Product]?, didFailWith error: Error?)
}

protocol CategoryDelegrate {
    func manager(_ manager: MarketManager, didGet marketingfemale: FemaleObject)
    func manager(_ manager: MarketManager, didFailWith error: Error)
}

class MarketManager {
    weak var delegate: MarketManagerDelegate?
    var categoryDelegrate: CategoryDelegrate?

    func getMarketingHots() {
        let urlString = "https://api.appworks-school.tw/api/1.0/marketing/hots"
        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.delegate?.manager(self, didFailWith: error!)
            }

            guard let data = data else { return }

            let decoder = JSONDecoder()

            do {
                let hots = try decoder.decode(DataProduct.self, from: data)
                self.delegate?.manager(self, didGet: hots.data)

            } catch {
                print(error)
            }
            }.resume()
    }

    func productList(endPoint: String, page: Int) {
        let baseURL = "https://api.appworks-school.tw/api/1.0/products"
        let query = "?paging=\(page)"

        let completeURL = baseURL + endPoint + query
        print(completeURL)
        Alamofire.request(completeURL).responseJSON { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let females = try decoder.decode(FemaleObject.self, from: data)
                    self.categoryDelegrate?.manager(self, didGet: females)
                } catch {
                    print(error)
                }
            }
      }
   }
}
