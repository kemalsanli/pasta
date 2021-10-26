//
//  HistoryCell.swift
//  Pasta
//
//  Created by Kemal on 20.10.2021.
//

import UIKit

protocol HistoryCellProtocol {
    func buttonClicked(indexPath:IndexPath)
}

class HistoryCell: UITableViewCell {

    @IBOutlet weak var pastaLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var HistoryCellProtocol:HistoryCellProtocol?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favButton(_ sender: Any) {
        HistoryCellProtocol?.buttonClicked(indexPath: indexPath!)
    }
    
}
