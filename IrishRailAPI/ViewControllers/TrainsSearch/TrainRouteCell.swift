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
    
    var defaultTextColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultTextColor = trainDueInLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ train: Train, toStation: TrainStation) {
        trainNameLabel.text = train.trainCode
        trainDueInLabel.text = "Due in: \(train.dueIn)"
        
        if train.type == .dart {
            trainImageView.image = UIImage(named: "dart_train_white_48pt")
        } else {
            trainImageView.image = UIImage(named: "train_white_48pt")
        }
        
        if train.isTransit(forStation: toStation) {
            trainImageView.tintColor = .systemGray
            trainExpectedArrival.text = "Transit"
            trainDueInLabel.textColor = .systemGray
        } else {
            setExpectedArrival(train, toStationCode: toStation.code)
            trainImageView.tintColor = AppConfig.appMainColor
            trainDueInLabel.textColor = defaultTextColor
        }
    }
    
    func isTrainTransit() -> Bool {
        return trainImageView.tintColor == .systemGray
    }
    
    private func setExpectedArrival(_ train: Train, toStationCode: String) {
        if let stationMovement = train.trainMovement.first(where: {(movement) -> Bool in
            movement.stationCode == toStationCode
        }), stationMovement.expectedArrival != "00:00:00" {
            trainExpectedArrival.text = "Expected Arrival:\n\(stationMovement.expectedArrival)"
        } else {
            trainExpectedArrival.text = ""
        }
    }

}
