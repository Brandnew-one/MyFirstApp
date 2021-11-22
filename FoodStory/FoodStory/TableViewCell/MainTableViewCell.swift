//
//  MainTableViewCell.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaryLabel: UILabel!
    
    
    func configureCell(row: UserDiary) {
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        editButton.setTitle("", for: .normal)
        profileName.text = row.foodTitle
        ratingLabel.text = "\(row.userRating)"
        dateLabel.text = dateCal(nowDate: row.writeDate)
        diaryLabel.text = row.foodMemo
        foodImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id).png")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
