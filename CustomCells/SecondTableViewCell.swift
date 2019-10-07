//
//  SecondTableViewCell.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/12.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView!

    @IBOutlet weak var middleTopImage: UIImageView!

    @IBOutlet weak var middleBottomImage: UIImageView!

    @IBOutlet weak var rightImage: UIImageView!

    @IBOutlet weak var secondTitleLabel: UILabel!

    @IBOutlet weak var secondDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
