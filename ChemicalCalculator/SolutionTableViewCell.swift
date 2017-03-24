//
//  SolutionTableViewCell.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/18/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit

class SolutionTableViewCell: UITableViewCell {
    
    
 
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var massLabel: UILabel!
    
    @IBOutlet weak var massUnitLabel: UILabel!
    
    @IBOutlet weak var concentrationLabel: UILabel!
    
    @IBOutlet weak var concentrationUnitLabel: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var volumeUnitLabel: UILabel!
    
    @IBOutlet weak var createdDateLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
