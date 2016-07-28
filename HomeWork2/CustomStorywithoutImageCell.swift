//
//  CustomStorywithoutImageCell.swift
//  HomeWork2
//
//  Created by student on 7/23/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class CustomStorywithoutImageCell: MGSwipeTableCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var pubDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
