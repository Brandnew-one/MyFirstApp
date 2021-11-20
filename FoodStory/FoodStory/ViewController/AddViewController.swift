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
    //초기에는 row 값을 넘겨주는 방법을 사용했는데 그냥 object 인스턴스를 넘겨받으면 object_ID 를 알기 때문에 좀 더 쉽게 수정 할 수 있음!!
    //isFiltering 분기처리를 하지 않아도 된다!
    var passedDiary: UserDiary = UserDiary(writeDate: Date(), userRating: 0.0, foodTitle: "", foodMemo: "")
    
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
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        //1. 이미지 저장할 경로 설정 : Document 폴더
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let filePath = documentDirectory.appendingPathComponent("Image")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        //Desktop/~~/~~/folder/222.png
        let imageURL = filePath.appendingPathComponent(imageName)
        
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
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let filePath = documentDirectory.appendingPathComponent("Image")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let imageURL = filePath.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: imageURL.path)
        
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