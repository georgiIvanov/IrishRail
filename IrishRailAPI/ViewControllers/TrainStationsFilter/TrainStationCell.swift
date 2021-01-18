//
//  TrainStationCell.swift
//  IrishRailAPI
//
//  Created by Voro on 17.01.21.
//

import UIKit

class TrainStationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ trainStation: TrainStation) {
        titleLabel.text = trainStation.nameAndAlias()
    }
}
