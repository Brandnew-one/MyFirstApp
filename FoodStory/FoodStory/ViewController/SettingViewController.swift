//
//  SettingViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import RealmSwift
import Zip
import UIKit
import MobileCoreServices

class SettingViewController: UIViewController {
    
    let settingImage: [String] = ["speaker.fill",  "tray.fill", "tray.and.arrow.down.fill"]
    let settingString: [String] = ["공지사항", "백업", "복구"]
    
    var localRealm = try! Realm()
    var profile: Results<Userprofile>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIntroductionLabel: UILabel!
    @IBOutlet weak var changeProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        profile = localRealm.objects(Userprofile.self)
        if !profile.isEmpty {
            userProfileImageView.image = loadImageFromDocumentDirectory(imageName: "\(profile[0]._id).png")
            userNameLabel.text = profile[0].userName
            userIntroductionLabel.text = profile[0].userIntroduction
        }
        
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        
        changeProfileButton.clipsToBounds = true
        changeProfileButton.layer.cornerRadius = 10
        changeProfileButton.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 15)
        changeProfileButton.setTitle("프로필 편집", for: .selected)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !profile.isEmpty {
            userProfileImageView.image = loadImageFromDocumentDirectory(imageName: "\(profile[0]._id).png")
            userNameLabel.text = profile[0].userName
            userIntroductionLabel.text = profile[0].userIntroduction
        }
    }
    
    // 백업할 파일이 있는지 확인 (도큐먼트 폴더 위치)
    func documentDirectoryPath() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask //디렉토리내 제한걸어 준다고생각
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        //path 는 배열형태, 0번째 인덱스에 url 이 저장된다
        
        if let directoryPath = path.first {
            return directoryPath
        }
        return nil
    }
    
    //7) 백업은 했는데 어디로 보낼까요? 띄워주는 창
    func presentActivityViewController() {
        //압축 파일 경로 가져오기
        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("TEST.zip")
        let fileURL = URL(fileURLWithPath: fileName)
        
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeProfileButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "SettingDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SettingDetailViewController") as! SettingDetailViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(imageName: settingImage[indexPath.row], settingString: settingString[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //백업
        if indexPath.row == 1 {
            var urlPath = [URL]()
            if let path = documentDirectoryPath() {
                let realm = (path as NSString).appendingPathComponent("default.realm")
                if FileManager.default.fileExists(atPath: realm) {
                    urlPath.append(URL(string: realm)!)
                }
                else {
                    print("Realm 파일이 존재하지 않습니다.")
                }
                
                let imageFile = (path as NSString).appendingPathComponent("Image")
                if FileManager.default.fileExists(atPath: imageFile) {
                    //5) URL 배열에 백업 파일 URL 추가
                    urlPath.append(URL(string: imageFile)!)
                }
                else {
                    print("백업할 이미지 파일이 존재하지 않습니다.")
                }
                
            }
            
            do {
                let zipFilePath = try Zip.quickZipFiles(urlPath, fileName: "TEST") // Zip
                print("압축경로: \(zipFilePath)")
                presentActivityViewController()
            }
            catch {
              print("Something went wrong")
            }
        }
        //복구
        else if indexPath.row == 2 {
            //복구1. 파일앱 열기 + 확장자 (import 잊지말기)
            let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.present(documentPicker, animated: true, completion: nil)
        }
    }
}

extension SettingViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(#function)
        
        //2) 선택한 파일에 대한 경로 가져와야 함(파일앱에 존재하는 백업 파일에 대한 경로)
        guard let selectedFileURL = urls.first else { return }
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = directory.appendingPathComponent(selectedFileURL.lastPathComponent) //우리가 파일앱에서 선택한 마지막 파일
        
        //3) 압축해제
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            //기존에 복구하고자 하는 zip 파일을 도큐먼트에 가지고 있을 경우, 도큐먼트에 위치한 zip 을 압축해제 하면됨
            do {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("TEST.zip")
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    //print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    //print("unzippedFile: \(unzippedFile)")
                })
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
            }
            catch {
                print("ERROR")
            }
        }
        
        else {
            //파일 앱의 zip -> 도큐먼트 폴더에 복사 하는 과정이 필요
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("TEST.zip")
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    //print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    //print("unzippedFile: \(unzippedFile)")
                })
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
            }
            catch {
                print("ERROR")
            }
        }
    }
}

