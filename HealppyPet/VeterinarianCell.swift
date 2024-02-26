//
//  VeterinarianCell.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 20.04.2023.
//

import UIKit

class VeterinarianCell: UITableViewCell {

    @IBOutlet weak var veterinarianImageView: UIImageView!
    
    @IBOutlet weak var vetNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func selectClicked(_ sender: Any) {
        
        
    }
    
    
    
}
