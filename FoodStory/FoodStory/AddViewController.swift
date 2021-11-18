//
//  AddViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import UIKit
import PhotosUI

class AddViewController: UIViewController {
    
    @IBOutlet weak var foodButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(saveButtonClicked))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.square"), style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    
    @IBAction func foodButtonClicked(_ sender: UIButton) {
        imageButtonClicked()
    }
    
    
    @objc
    func saveButtonClicked() {
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func imageButtonClicked() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
}

extension AddViewController: PHPickerViewControllerDelegate {
    
    //선택하고 종료되는 시점에 호출되는 함수라고 생각 (꼭 취소버튼을 기점으로 생각하지 말 것)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function)
        dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider // 2
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    self.foodButton.setImage(image as? UIImage, for: .normal)
                    //self.foodButton.image = image as? UIImage
                }
            }
        }
        else {
            //얼럿으로 선택한 사진을 이용할 수 없다고 사용자에게 알려주는 과정 필요
            print("else 문으로 들어왔습니다.")
        }

    }
    
}
