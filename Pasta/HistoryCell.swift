//
//  HistoryCell.swift
//  Pasta
//
//  Created by Kemal on 20.10.2021.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var pastaLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favButton(_ sender: Any) {
    }
    @IBAction func deleteButton(_ sender: Any) {
    }
    
}
