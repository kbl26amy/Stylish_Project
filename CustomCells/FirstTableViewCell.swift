//
//  FirstTableViewCell.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/12.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!

    @IBOutlet weak var firstTitleLabel: UILabel!

    @IBOutlet weak var firstDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
