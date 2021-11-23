//
//  SettingTableViewCell.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/23.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(imageName: String, settingString: String) {
        settingImageView.image = UIImage(systemName: imageName)!
        settingLabel.text = settingString
    }
    
}
