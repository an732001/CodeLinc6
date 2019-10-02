//
//  ResultsTableViewCell.swift
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var container: ResultsTableViewCellContainer!
    @IBOutlet weak var disorderLabel: UILabel!
    @IBOutlet weak var chanceLabel: UILabel!

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        container.setShrunk(highlighted, animated: true)
    }

}
