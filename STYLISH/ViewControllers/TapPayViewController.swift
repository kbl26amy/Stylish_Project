//
//  TapPayViewController.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/30.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit

class TapPayViewController: UIViewController {

    @IBOutlet weak var tapPayUIView: UIView!
    @IBOutlet weak var tapPayUIButton: UIButton!
    lazy var tapPrime = "no tapPrime"
    var tpdForm: TPDForm!
    var tpdCard: TPDCard!
    
    var order = Order(shipping: "", payment: "", subtotal: 0,
                      freight: 0, total: 0,
                      recipient: Recipient(name: "", phone: "", email: "", address: "", time: ""),
                      list: [List(id: "", name: "", price: 0, color: ColorObject(name: "", code: ""),
                                  size: "", qtn: 0)])

    @IBAction func tapPayButionClick(_ sender: Any) {
 
        tpdCard.onSuccessCallback { (prime, cardInfo) in
            
            print(self.order)
            self.tapPrime = prime ?? "no prime"
            print(self.tapPrime)
           
             self.checkoutAPI()
            
                }.onFailureCallback { (status, message) in
                    print("status : \(status) , Message : \(message)")
                }.getPrime()
        }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tpdForm = TPDForm.setup(withContainer: tapPayUIView)
        self.tpdCard = TPDCard.setup(self.tpdForm)
        tpdForm.setErrorColor(UIColor.red)
        tpdForm.setOkColor(UIColor.green)
        tpdForm.setNormalColor(UIColor.black)
      
        self.tpdForm.onFormUpdated { (status) in
            self.tapPayUIButton.isEnabled = status.isCanGetPrime()
            self.tapPayUIButton.alpha = (status.isCanGetPrime()) ? 1.0 : 0.25
        }
        self.tapPayUIButton.isEnabled = false
        self.tapPayUIButton.alpha = 0.25
    }
    
    func checkoutAPI() {
        
        var request = URLRequest(url: URL(string: "https://api.appworks-school.tw/api/1.0/order/checkout")!)

        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
 
        let body = ServerCheckOut(prime: tapPrime, order: order)

        let data = try?  JSONEncoder().encode(body)

        request.httpBody = data
        URLSession.shared.dataTask(with: request, completionHandler: { (data, responce, error) in

            if error != nil {
                print("error")
                return
            }
            guard let httpResponce = responce as? HTTPURLResponse else { return }

            let statusCode = httpResponce.statusCode
            if httpResponce.statusCode >= 200 && statusCode < 300 {
                guard let data = data else { return }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    print(json)
                    print(statusCode)
                    DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                    }
                } catch {
                    print(error)
                }
            } else if statusCode >= 400 {
                print("error")
            } else {
                print("server error")
            }
        }).resume()
    }
}
