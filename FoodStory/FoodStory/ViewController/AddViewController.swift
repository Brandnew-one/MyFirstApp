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
    var row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicekd))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.square"), style: .plain, target: self, action: #selector(saveButtonClicked))
        
        diary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
        
        //Slider 를 위한 설정
        initSlider()
        for i in 0...4 {
            starImageViews.append(starStackView.subviews[i] as? UIImageView ?? UIImageView())
        }
        
        //수정 모드로 들어온 경우에는 이미지를 보여줄 수 있도록 설정
        if isEditingMode {
            foodButton.setImage(loadImageFromDocumentDirectory(imageName: "\(diary[row]._id)"), for: .normal)
            //starSlider.value = (Float)(diary[row].userRating) //딜레이와 함께 별점이 바뀌지 않음
            datePicker.date = diary[row].writeDate
            foodNameTextField.placeholder = diary[row].foodTitle
            foodDiaryTextView.text = diary[row].foodMemo
        }
        
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let datePickerView = sender
//        let date = DateFormatter()
//        date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
//        date.locale = Locale(identifier: "ko_KR")
//        let stringDate = date.string(from: datePickerView.date)
//        self.writeDate = date.date(from: stringDate)!
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
        //navigationController?.popViewController(animated: true)
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
        else {
            
        }
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
    
    
    @objc
    func slideStarSlider() {
        var value = starSlider.value
        //print(value)
        
        for i in 0...4 {
            if value > 0.5 {
                value -= 1
                starImageViews[i].image = UIImage(systemName: "star.fill")
            }
            else if value > 0 && value < 0.5 {
                value -= 0.5
                starImageViews[i].image = UIImage(systemName: "star.leadinghalf.filled")
            }
            else {
                starImageViews[i].image = UIImage(systemName: "star")
            }
        }
    }
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        //1. 이미지 저장할 경로 설정 : Document 폴더
        //Desktop/~~/~~/folder
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        //Desktop/~~/~~/folder/222.png
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3. 이미지 압축(optional) image.pngData()
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인 (만약 최종 경로에 동일한 파일이 있는 경우)
        if FileManager.default.fileExists(atPath: imageURL.path) {
            //4-2. 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            }
            catch {
                print("이미지 삭제하지 못했습니다.")
            }
        }
        
        //5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
        }
        catch {
            print("이미지 저장 실패")
        }
    }
    
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)
        }
        return nil
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
    
    //선택하고 종료되는 시점에 호출되는 함수라고 생각 (꼭 취소버튼을 기점으로 생각하지 말 것)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function)
        dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider // 2
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    self.foodButton.setImage(image as? UIImage, for: .normal)
                }
            }
        }
        else {
            //얼럿으로 선택한 사진을 이용할 수 없다고 사용자에게 알려주는 과정 필요
            print("else 문으로 들어왔습니다.")
        }

    }
}
