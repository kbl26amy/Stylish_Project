//
//  ClothesTableViewCell.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/16.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit

class ClothesTableViewCell: UITableViewCell {

    @IBOutlet weak var clothesImage: UIImageView!

    @IBOutlet weak var clothesTitle: UILabel!

    @IBOutlet weak var clothesPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
