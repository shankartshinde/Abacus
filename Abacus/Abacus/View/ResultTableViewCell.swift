//
//  ResultTableViewCell.swift
//  Abacus
//
//  Created by AyunaLabs on 01/12/21.
//

import UIKit



class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var totalAttemptSum: UILabel!
    @IBOutlet weak var correctAnswersLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
