//
//  CartTableViewCell.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/24.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    weak var viewController: CartViewController?
    
    @IBOutlet weak var cartImage: UIImageView!
    
    @IBOutlet weak var cartTitle: UILabel!
    
    @IBOutlet weak var cartColor: UIImageView!
    
    @IBOutlet weak var cartPrice: UILabel!
    
    @IBOutlet weak var cartSize: UILabel!
    
    @IBOutlet weak var cartTextFieldText: UITextField!
    
    @IBOutlet weak var cartAddButton: UIButton!
    
    @IBOutlet weak var cartDecreaseButton: UIButton!
    
    @IBAction func clickAddButton(_ sender: UIButton) {
        viewController?.addDidHitButtonInCell(self)
    }
    
    @IBAction func clickDreaseButton(_ sender: UIButton) {
        viewController?.decreaseDidHitButtonInCell(self)
    }
    
    @IBAction func removeButton(_ sender: UIButton) {
        viewController?.removeDidHitButtonInCell(self)
    }
    
    @IBAction func cartTextField(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
