//
//  DetailTableViewCell.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/19.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var colorCollectionViewController: UICollectionViewFlowLayout!

    @IBOutlet weak var colorCollectionView: UICollectionView!

    @IBOutlet weak var sizeLabel: UILabel!

    @IBOutlet weak var storeNumber: UILabel!

    @IBOutlet weak var structure: UILabel!

    @IBOutlet weak var washFunc: UILabel!

    @IBOutlet weak var location: UILabel!

    @IBOutlet weak var otherWords: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
