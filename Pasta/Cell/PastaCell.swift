//
//  PastaCell.swift
//  Pasta
//
//  Created by Kemal on 19.10.2021.
//

import UIKit

class PastaCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var pastaLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hourBorderStyle: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.layer.cornerRadius = 15
        hourBorderStyle.layer.cornerRadius = 5
        subView.clipsToBounds = true
        hourBorderStyle.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let alpha2 = pastaLabel.alpha
        pastaLabel.alpha = 0
        UIView.animate(withDuration: 0.25){
            self.pastaLabel.alpha = alpha2
        }
        
    }
}
