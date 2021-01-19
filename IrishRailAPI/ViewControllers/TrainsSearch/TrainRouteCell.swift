//
//  TrainRouteCell.swift
//  IrishRailAPI
//
//  Created by Voro on 19.01.21.
//

import UIKit

class TrainRouteCell: UITableViewCell {

    @IBOutlet weak var trainImageView: UIImageView!
    @IBOutlet weak var trainNameLabel: UILabel!
    @IBOutlet weak var trainDueInLabel: UILabel!
    @IBOutlet weak var trainExpectedArrival: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ train: Train, toStation: TrainStation) {
        if let stationMovement = train.trainMovement.first(where: {(movement) -> Bool in
            movement.stationCode == toStation.code
        }) {
            trainExpectedArrival.text = "Expected Arrival:\n\(stationMovement.expectedArrival)"
        } else {
            trainExpectedArrival.text = ""
        }
        
        trainNameLabel.text = train.trainCode
        trainDueInLabel.text = "Due in: \(train.dueIn)"
    }

}
