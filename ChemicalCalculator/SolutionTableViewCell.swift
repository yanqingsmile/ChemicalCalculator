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
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var stockNeededVolumeLabel: UILabel!
    
    @IBOutlet weak var stockNeededVolumeUnitLabel: UILabel!
    
    @IBOutlet weak var stockConcentrationLabel: UILabel!
    
    @IBOutlet weak var stockConcentrationUnitLabel: UILabel!
    
    
    @IBOutlet weak var disclosureIndicator: UIImageView! {
        didSet {
            let image = UIImage(named:"chevron_grey")?.withRenderingMode(.alwaysTemplate)
            disclosureIndicator.tintColor = UIColor.warmOrange()
            disclosureIndicator.image = image
        }
    }
    
    @IBOutlet weak var dilutedIcon: UIImageView!{
        didSet {
            let image = UIImage(named: "diluted")?.withRenderingMode(.alwaysTemplate)
            dilutedIcon.tintColor = UIColor.mintBlue()
            dilutedIcon.image = image
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func layoutSubviews() {
        cardSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func cardSetup() {
        cardView.layer.cornerRadius = 10
    }

}
