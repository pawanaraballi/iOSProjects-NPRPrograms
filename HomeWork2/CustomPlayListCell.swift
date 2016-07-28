//
//  CustomPlayListCell.swift
//  HomeWork2
//
//  Created by Udit  Khanna on 7/24/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class CustomPlayListCell: MGSwipeTableCell {

    @IBOutlet weak var audiotitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
