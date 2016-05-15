//
//  GroupDisplayCell.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/12/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class GroupDisplayCell: UITableViewCell {

    @IBOutlet weak var taskStatusIndicator: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageStar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
