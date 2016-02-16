//
//  LevelScoreCell.swift
//  JumperCrab
//
//  Created by fingent on 10/11/15.
//  Copyright (c) 2015 Fullstack.io. All rights reserved.
//

import UIKit

class LevelScoreCell: UITableViewCell {

    @IBOutlet weak var scoreItemImage: UIImageView!
    @IBOutlet weak var scoreItemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
