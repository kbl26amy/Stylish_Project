//
//  CartViewController.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/24.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var datas: [Bool] = {
        var array: [Bool] = []
        for number in 0...1000 {
            array.append(false)
        }
        return array
    }()
    
    @IBOutlet weak var cartTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("+++++++++++++++\(StorageManager.storagsharedmanager.getBuyItem().count)")
        return StorageManager.storagsharedmanager.getBuyItem().count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cartIdentifier", for: indexPath) as? CartTableViewCell else {
                return UITableViewCell()
        }
        guard let passbutton = cell as? CartTableViewCell else { return cell }
        passbutton.viewController = self
        
        cell.cartTitle.text = StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].title
        cell.cartPrice.text = "NT$ \(StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].price)"
        cell.cartColor.backgroundColor =
            UIColor(hexString: StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].color ?? "no color")
        cell.cartSize.text = StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].size
        let url = URL(string: StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].mainImage ?? "no Image")
        cell.cartImage.kf.setImage(with: url)
        cell.cartTextFieldText.text = "\(StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].buycount)"
        
        if datas[indexPath.row] {
            cell.cartTextFieldText.text = "\(StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].buycount)"
        } else {
        }
        return cell
    }
    
    var finalBuyCount: Int = 0
    func addDidHitButtonInCell(_ cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else {
            return
        }
        cell.cartDecreaseButton.isEnabled = true
        cell.cartDecreaseButton.alpha = 1
       
        StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].buycount += 1
        
        cell.cartTextFieldText.text = "\(StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].buycount)"
        
        StorageManager.storagsharedmanager.saveContext()
        
        datas[indexPath.row] = true
        
        if StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].buycount >=
            StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].variant {
            cell.cartAddButton.isEnabled = false
            cell.cartAddButton.alpha = 0.3
        }
         print("touchaddbutton")
    }
    func decreaseDidHitButtonInCell(_ cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else {
            return
        }
        cell.cartAddButton.isEnabled = true
        cell.cartAddButton.alpha = 1
        
        StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].buycount -= 1
        cell.cartTextFieldText.text = "\(StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].buycount)"
        
        StorageManager.storagsharedmanager.saveContext()
   
        if StorageManager.storagsharedmanager.getBuyItem()[indexPath.row].buycount <= 1 {
            cell.cartDecreaseButton.isEnabled = false
            cell.cartDecreaseButton.alpha = 0.3
        }
        print("touchdreasebutton")
    }
    
    func removeDidHitButtonInCell(_ cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else {
            return
        }
        print("click delete")
        
        StorageManager.storagsharedmanager.viewContext.delete(StorageManager.storagsharedmanager.getBuyItem(
            )[indexPath.row])
        StorageManager.storagsharedmanager.removeBuyItem(position: indexPath.row)
        cartTableView.deleteRows(at: [indexPath], with: .top)
        
        finalBuyCount = [StorageManager.storagsharedmanager.getBuyItem()].count
        do {
            try  StorageManager.storagsharedmanager.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        NotificationCenter.default.post(name: .didUpdateBuyItemList, object: self, userInfo: nil)
        
        if StorageManager.storagsharedmanager.getBuyItem().count == 0 {
            noDataHint.alpha = 1 } else {
            self.noDataHint.alpha = 0
        }
    }
 
    @IBOutlet weak var noDataHint: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        self.cartTableView.separatorStyle = .none
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      self.tabBarController?.tabBar.isHidden = false
           StorageManager.storagsharedmanager.fetchBuyItem()
        if StorageManager.storagsharedmanager.getBuyItem().count == 0 {
            noDataHint.alpha = 1 } else {
            self.noDataHint.alpha = 0
        }
        
         cartTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
   
    @IBAction func comeToPayButton(_ sender: Any) {
    
    }
}
