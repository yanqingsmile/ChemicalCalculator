//
//  GroupTableViewCell.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/26/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var modifiedDateLabel: UILabel!
    
    @IBOutlet weak var lastModifiedNoteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
