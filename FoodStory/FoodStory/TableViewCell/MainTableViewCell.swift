//
//  MainTableViewCell.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {

  static let identifier = "MainTableViewCell"

  @IBOutlet weak var overView: UIView!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var centerView: UIView!
  @IBOutlet weak var bottomView: UILabel!
  @IBOutlet weak var bottomView2: UIView!

  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var profileName: UILabel!
  @IBOutlet weak var editButton: UIButton!

  @IBOutlet weak var foodImageView: UIImageView!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var diaryLabel: UILabel!

  private func setupCell() {
    [overView, topView, centerView, bottomView, bottomView2].forEach {
      $0?.clipsToBounds = true
      $0?.layer.cornerRadius = 10
    }

    topView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    centerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

    profileImage.clipsToBounds = true
    profileImage.layer.cornerRadius = profileImage.frame.height / 2
  }

  func configureCell(row: UserDiary) {
    setupCell()

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
