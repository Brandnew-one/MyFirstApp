//
//  MainViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import RealmSwift
import UIKit

class MainViewController: UIViewController {
    
    var searchController: UISearchController!
    var localRealm = try! Realm()
    var diary: Results<UserDiary>!
    var diarySearch: Results<UserDiary>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: MainTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: MainTableViewCell.identifier)
        let nibSearch = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        tableView.register(nibSearch, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = "제목"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        
        print("Realm:",localRealm.configuration.fileURL!)
        diary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
        diarySearch = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
      return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    //처음 게시글을 작성하는 경우
    //push-pop 으로 하면 탭바 때문에 일기를 작성할 수 있는 공간이 줄어드는 문제점
    @objc
    func addButtonClicked() {
        let sb = UIStoryboard(name: "Add", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //메인화면에서 수정버튼을 누른 경우
    //Realm 추가하고 passData 설정해주는 과정 필요
    @objc
    func editButtonClicked(editButton: UIButton) {
        let sb = UIStoryboard(name: "Add", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        let nav = UINavigationController(rootViewController: vc)
        
        vc.isEditingMode = true
        if isFiltering() {
            vc.passedDiary = diarySearch[editButton.tag]
        }
        else {
            vc.passedDiary = diary[editButton.tag]
        }
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
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
    
    func deleteImageFromDocumentDirectory(imageName: String) {

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
    }
}



extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        dump(searchController.searchBar.text)
        guard let text = searchController.searchBar.text else { return }
        let predicate = NSPredicate(format: "foodTitle CONTAINS[c] %@ OR foodMemo CONTAINS[c]  %@",text as CVarArg,text as! CVarArg)
        self.diarySearch = diary.filter(predicate)
        tableView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return diarySearch.count
        }
        else {
            return diary.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFiltering() {
            return UIScreen.main.bounds.height * 0.7
        }
        else {
            return UIScreen.main.bounds.height * 0.7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Table Cell 새로운 디자인 필요 (만들긴 했지만 너무 구림...)
        if isFiltering() {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier) as? MainTableViewCell else {
                return UITableViewCell()
            }
            
            let row = diarySearch[indexPath.row]
            
//            cell.foodImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id).png")
//
//            cell.foodNameLabel.text = row.foodTitle
//            cell.ratingLabel.text = "\(row.userRating)"
//            let date = DateFormatter()
//            date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
//            date.locale = Locale(identifier: "ko_KR")
//            let nowDate = date.string(from: row.writeDate)
//            cell.dateLabel.text = nowDate
//            cell.diaryLabel.text = row.foodMemo
            
            cell.profileImage.clipsToBounds = true
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
            cell.editButton.setTitle("", for: .normal)
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editButtonClicked(editButton:)), for: .touchUpInside)
            
            cell.profileName.text = row.foodTitle
            cell.ratingLabel.text = "\(row.userRating)"
            cell.diaryLabel.text = row.foodMemo
            cell.foodImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id).png")
            
            return cell
        }
        
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier) as? MainTableViewCell else {
                return UITableViewCell()
            }
            
            cell.profileImage.clipsToBounds = true
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
            cell.editButton.setTitle("", for: .normal)
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editButtonClicked(editButton:)), for: .touchUpInside)
            
            let row = diary[indexPath.row]
            cell.profileName.text = row.foodTitle
            cell.ratingLabel.text = "\(row.userRating)"
            cell.diaryLabel.text = row.foodMemo
            cell.foodImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id).png")
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let alert = UIAlertController(title: "일기를 삭제", message: "일기를 삭제하겠습니다.", preferredStyle: .alert)
            let del = UIAlertAction(title: "확인", style: .default) { _ in
                print("메모 삭제를 실행합니다.")
                
                if self.isFiltering() {
                    let row = self.diarySearch[indexPath.row]
                    try! self.localRealm.write {
                        self.deleteImageFromDocumentDirectory(imageName: "\(row._id).png")
                        self.localRealm.delete(row)
                    }
                }
    
                else {
                    let row = self.diary[indexPath.row]
                    try! self.localRealm.write {
                        self.deleteImageFromDocumentDirectory(imageName: "\(row._id).png")
                        self.localRealm.delete(row)
                    }
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            let cancle = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(del)
            alert.addAction(cancle)
            
            self.present(alert, animated: true) {
                print("얼럿이 올라왔습니다")
            }
            success(true)
        })
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
}

