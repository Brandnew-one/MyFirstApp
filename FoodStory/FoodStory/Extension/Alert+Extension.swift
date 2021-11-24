//
//  Alert+Extension.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(okAction: @escaping () -> ()) {
        let alert = UIAlertController(title: "복구를 진행합니다.", message: "복구가 완료되면 앱을 종료하겠습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
//            print("백업을 완료하면 앱을 재실행합니다.")
            okAction()
        }
        
        alert.addAction(ok)
        self.present(alert,animated: true) {
//            print("얼럿이 떴습니다~!")
        }
    }
    
}
