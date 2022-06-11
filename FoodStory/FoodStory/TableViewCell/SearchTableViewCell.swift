//
//  SearchTableViewCell.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/20.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

  static let identifier = "SearchTableViewCell"

  @IBOutlet weak var foodImageView: UIImageView!
  @IBOutlet weak var foodNameLabel: UILabel!
  @IBOutlet weak var diaryLabel: UILabel!
  @IBOutlet var starImageViews: [UIImageView]!
  @IBOutlet weak var overView: UIView!


  func configureCell(row: UserDiary) {
    overView.clipsToBounds = true
    overView.layer.cornerRadius = 10

    foodImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id).png")
    foodNameLabel.text = row.foodTitle
    diaryLabel.text = row.foodMemo
    fillStarImage(userRating: row.userRating, starImages: starImageViews)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }


}
