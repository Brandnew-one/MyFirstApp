//
//  Alert+Extension.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/24.
//

import Foundation
import UIKit

extension UIViewController {

  // MARK: - Delete & Edit
  func removableActionSheet(deleteAction: @escaping () -> (), editAction: @escaping () -> () ) {
    let alert = UIAlertController(
      title: "삭제/수정",
      message: "일기를 삭제하거나 수정해보세요. ",
      preferredStyle: .actionSheet
    )

    let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in deleteAction() }
    let edit = UIAlertAction(title: "수정", style: .default) { _ in editAction() }
    let cancle = UIAlertAction(title: "취소", style: .cancel)

    alert.addAction(delete)
    alert.addAction(edit)
    alert.addAction(cancle)

    self.present(alert, animated: true)
  }

  // MARK: - Restore DB
  func RestoreAlert(okAction: @escaping () -> ()) {
    let alert = UIAlertController(
      title: "복구를 진행합니다.",
      message: "복구가 완료되면 앱을 종료하겠습니다.",
      preferredStyle: .alert
    )
    let ok = UIAlertAction(title: "확인", style: .default) { _ in okAction() }

    alert.addAction(ok)
    self.present(alert,animated: true)
  }

  // MARK: - Image Doesn't pick
  func imageNilAlert(okAction: @escaping () -> ()) {
    let alert = UIAlertController(
      title: "이미지가 설정되지 않았어요",
      message: "이미지를 선택해주세요",
      preferredStyle: .alert
    )
    let ok = UIAlertAction(title: "확인", style: .default) { _ in okAction() }

    alert.addAction(ok)
    self.present(alert,animated: true)
  }

  // MARK: - Image Error
  func imageErrorAlert(okAction: @escaping () -> ()) {
    let alert = UIAlertController(
      title: "해당 이미지를 사용할 수 없습니다.",
      message: "HDR 파일은 사용할 수 없습니다.",
      preferredStyle: .alert
    )
    let ok = UIAlertAction(title: "확인", style: .default) { _ in okAction() }

    alert.addAction(ok)
    self.present(alert,animated: true)
  }


  func authorizationAlert(
    title: String,
    message: String,
    okTitle: String,
    okAction: @escaping () -> ()
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    let ok = UIAlertAction(title: okTitle, style: .default) { _ in okAction() }

    alert.addAction(cancel)
    alert.addAction(ok)

    self.present(alert, animated: true)
  }
}
