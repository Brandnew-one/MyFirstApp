//
//  AddViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import RealmSwift
import MobileCoreServices
import UIKit
import PhotosUI

class AddViewController: UIViewController {

  @IBOutlet weak var foodButton: UIButton!
  @IBOutlet weak var starStackView: UIStackView!
  @IBOutlet weak var starSlider: UISlider!

  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var foodNameTextField: UITextField!
  @IBOutlet weak var foodDiaryTextView: UITextView!


  var starImageViews = [UIImageView]()
  var localRealm = try! Realm()
  var diary: Results<UserDiary>!
  var writeDate: Date = Date()
  var isEditingMode = false
  var passedDiary: UserDiary = UserDiary(writeDate: Date(), userRating: 0.0, foodTitle: "", foodMemo: "")

  override func viewDidLoad() {
    super.viewDidLoad()

    
    self.navigationController?.navigationBar.prefersLargeTitles = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicekd))
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor(rgb: 0x3F674C)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.square"), style: .plain, target: self, action: #selector(saveButtonClicked))
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x3F674C)

    foodNameTextField.clipsToBounds = true
    foodNameTextField.layer.cornerRadius = 10
    foodNameTextField.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 13)!
    foodDiaryTextView.clipsToBounds = true
    foodDiaryTextView.layer.cornerRadius = 10
    foodDiaryTextView.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 13)!

    diary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)

    //Slider 를 위한 설정
    initSlider()
    for i in 0...4 {
      starImageViews.append(starStackView.subviews[i] as? UIImageView ?? UIImageView())
    }

    //수정 모드로 들어온 경우에는 이미지를 보여줄 수 있도록 설정
    if isEditingMode {
      foodButton.setImage(loadImageFromDocumentDirectory(imageName: "\(passedDiary._id).png"), for: .normal)
      let preValue = (Float)(passedDiary.userRating)
      print(preValue)
      starSlider.value = preValue //값만 넣어주니까 슬라이더가 반응하지 않고 딜레이가 생김
      slideStarSlider()

      datePicker.date = passedDiary.writeDate
      writeDate = datePicker.date
      foodNameTextField.text = passedDiary.foodTitle
      foodDiaryTextView.text = passedDiary.foodMemo
    }
  }

  @IBAction func datePickerAction(_ sender: UIDatePicker) {
    let datePickerView = sender
    self.writeDate = datePickerView.date
  }


  func initSlider() {
    starSlider.setThumbImage(UIImage(), for: .normal)
    starSlider.addTarget(self, action: #selector(slideStarSlider), for: UIControl.Event.valueChanged)
  }


  @IBAction func foodButtonClicked(_ sender: UIButton) {
    imageButtonClicked()
  }

  @objc
  func backButtonClicekd() {
    dismiss(animated: true, completion: nil)
  }

  @objc
  func saveButtonClicked() {

    if foodButton.currentImage!.isSymbolImage {
      imageNilAlert {
        print("이미지가 선택되지 않았습니다.")
      }
    }
    else {
      if !isEditingMode {
        let writeDate = self.writeDate
        let userRating = unitValue()
        let foodTitle = foodNameTextField.text!
        let foodMemo = foodDiaryTextView.text!
        let task = UserDiary(writeDate: writeDate, userRating: Double(userRating), foodTitle: foodTitle, foodMemo: foodMemo)
        try! localRealm.write {
          localRealm.add(task)
          saveImageToDocumentDirectory(imageName: "\(task._id).png", image: foodButton.currentImage!)
        }
      }

      //추후에 필터기능을 추가하면 diary 를 부르는 과정을 필터에 따라 분기처리하는 과정이 필요하다
      else {
        let taskToUpdate = passedDiary
        try! localRealm.write {
          taskToUpdate.writeDate = self.writeDate
          taskToUpdate.userRating = Double(unitValue())
          taskToUpdate.foodTitle = foodNameTextField.text!
          taskToUpdate.foodMemo = foodDiaryTextView.text
          saveImageToDocumentDirectory(imageName: "\(taskToUpdate._id).png", image: foodButton.currentImage!)
        }
      }
      dismiss(animated: true, completion: nil)
    }
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


  @objc
  func slideStarSlider() {
    var value = starSlider.value
    //print(value)

    for i in 0...4 {
      if value > 0.5 {
        value -= 1
        starImageViews[i].image = UIImage(systemName: "star.fill")
      }
      else if value > 0 && value <= 0.5 {
        value -= 0.5
        starImageViews[i].image = UIImage(systemName: "star.leadinghalf.filled")
      }
      else {
        starImageViews[i].image = UIImage(systemName: "star")
      }
    }
  }

  func unitValue() -> Double {

    var userRating: Double = 0.0
    for image in starImageViews {
      if image.image == UIImage(systemName: "star.fill") {
        userRating += 1
      }
      else if image.image == UIImage(systemName: "star.leadinghalf.filled") {
        userRating += 0.5
      }
    }
    return userRating
  }

}

extension AddViewController: PHPickerViewControllerDelegate {

  func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
    let newWidth = newWidth / 2
    let newHeight = newHeight / 2
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
          if let galleryImage = image as? UIImage {
            let resizeImage = self.resizeImage(image: galleryImage, newWidth: galleryImage.size.width, newHeight: galleryImage.size.height)
            self.foodButton.setImage(resizeImage as? UIImage, for: .normal)
            print("이미지 선택완료")
          }
          else {
            self.imageErrorAlert {
              print("이미지 선택 실패")
            }
          }
        }
      }
    }
    else {
      //얼럿으로 선택한 사진을 이용할 수 없다고 사용자에게 알려주는 과정 필요
      print("else 문으로 들어왔습니다.")
    }
  }
}
