//
//  Alert+Extension.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    //수정 or 삭제를 선택할 수 있도록 설정
    func showActionSheet(deleteAction: @escaping () -> (), editAction: @escaping () -> () ) {
        
        let alert = UIAlertController(title: "삭제/수정", message: "일기를 삭제하거나 수정해보세요. ", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            deleteAction()
        }
        let edit = UIAlertAction(title: "수정", style: .default) { _ in
            editAction()
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(edit)
        alert.addAction(cancle)
        
        self.present(alert, animated: true) {
            print("액션시트가 올라왔습니다")
        }
    }
    
    
    func showAlert(okAction: @escaping () -> ()) {
        let alert = UIAlertController(title: "복구를 진행합니다.", message: "복구가 완료되면 앱을 종료하겠습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            okAction()
        }
        
        alert.addAction(ok)
        self.present(alert,animated: true) {
        }
    }
    
}
