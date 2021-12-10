//
//  SettingDetailViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/23.
//

import RealmSwift
import UIKit
import PhotosUI

class SettingDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextView: UITextView!
    @IBOutlet weak var userIntroductionTextView: UITextView!
    @IBOutlet weak var changeButton: UIButton!
    
    var configuration = PHPickerConfiguration()
    var localRealm = try! Realm()
    var profile: Results<Userprofile>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicekd))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.square"), style: .plain, target: self, action: #selector(saveButtonClicekd))
        self.navigationItem.title = "프로필 설정"
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(rgb: 0x3F674C)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x3F674C)
        
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        profile = localRealm.objects(Userprofile.self)
        // 만약 이전에 사용자가 작성한 프로필이 존재한다면 화면에 띄워주는 과정이 필요
        if !profile.isEmpty {
            profileImageView.image = loadImageFromDocumentDirectory(imageName: "\(profile[0]._id).png")
            userNameTextView.text = profile[0].userName
            userIntroductionTextView.text = profile[0].userIntroduction
        }
        
        changeButton.setTitle("프로필 사진 바꾸기", for: .selected)
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        userNameTextView.clipsToBounds = true
        userNameTextView.layer.cornerRadius = 10
        userNameTextView.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 13)

        userIntroductionTextView.clipsToBounds = true
        userIntroductionTextView.layer.cornerRadius = 10
        userIntroductionTextView.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 13)
        
        changeButton.clipsToBounds = true
        changeButton.layer.cornerRadius = 10
        changeButton.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 13)
        
    }
    
    @IBAction func changeImageButtonClicked(_ sender: UIButton) {
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc
    func backButtonClicekd() {
        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func saveButtonClicekd() {
        
        if profileImageView.image!.isSymbolImage {
            imageAlert {
                print("이미지가 설정되지 않았어요")
            }
        }
        else {
            if profile.isEmpty {
                let userName = userNameTextView.text ?? ""
                let userIntroduction = userIntroductionTextView.text ?? ""
                let task = Userprofile(userName: userName, userIntroduction: userIntroduction)
                try! localRealm.write {
                    localRealm.add(task)
                    saveImageToDocumentDirectory(imageName: "\(task._id).png", image: profileImageView.image!)
                }
            }
            else {
                let taskToUpdate = profile[0]
                try! localRealm.write {
                    taskToUpdate.userName = userNameTextView.text ?? ""
                    taskToUpdate.userIntroduction = userIntroductionTextView.text ?? ""
                    saveImageToDocumentDirectory(imageName: "\(taskToUpdate._id).png", image: profileImageView.image!)
                }
            }
            navigationController?.popViewController(animated: true)
//            dismiss(animated: true, completion: nil)
        }
    }
}


extension SettingDetailViewController: PHPickerViewControllerDelegate {
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let newWidth = newWidth/2
        let newHeight = newHeight/2
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //선택하고 종료되는 시점에 호출되는 함수라고 생각 (꼭 취소버튼을 기점으로 생각하지 말 것)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function)
        dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider // 2
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    let galleryImage = image as! UIImage
                    let resizeImage = self.resizeImage(image: galleryImage, newWidth: galleryImage.size.width, newHeight: galleryImage.size.width)
                    self.profileImageView.image = resizeImage as? UIImage
                }
            }
        }
        else {
            //얼럿으로 선택한 사진을 이용할 수 없다고 사용자에게 알려주는 과정 필요
            print("else 문으로 들어왔습니다.")
        }
    }
}
