//
//  FavCell.swift
//  Pasta
//
//  Created by Kemal on 26.10.2021.
//

import UIKit

protocol FavCellProtocol {
    func buttonClicked(indexPath:IndexPath)
}

class FavCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    var FavCellProtocol:FavCellProtocol?
    var indexPath:IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionsButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
        subView.layer.cornerRadius = 15
        subView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func optionsButtonClicked(_ sender: UIButton) {
        FavCellProtocol?.buttonClicked(indexPath: indexPath!)
    }
    

}
