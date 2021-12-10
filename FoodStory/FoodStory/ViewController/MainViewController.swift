//
//  MainViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import RealmSwift
import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    var searchController: UISearchController!
    var localRealm = try! Realm()
    var diary: Results<UserDiary>!
    var diarySearch: Results<UserDiary>!
    var profile: Results<Userprofile>!
    
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
        searchController.searchBar.tintColor = UIColor(rgb: 0x3F674C)

        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = "Foodie Story"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonClicked))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x3F674C)
        
        print("Realm:",localRealm.configuration.fileURL!)
        diary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
        diarySearch = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
        profile = localRealm.objects(Userprofile.self)
        
//        for family in UIFont.familyNames {
//            print(family)
//
//            for sub in UIFont.fontNames(forFamilyName: family) {
//                print("=======> \(sub)")
//            }
//        }
        
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
        
        showActionSheet {
            print("삭제 구현해야 하무니다")
            if self.isFiltering() {
                let row = self.diarySearch[editButton.tag]
                try! self.localRealm.write {
                    self.deleteImageFromDocumentDirectory(imageName: "\(row._id).png")
                    self.localRealm.delete(row)
                }
            }
            else {
                let row = self.diary[editButton.tag]
                try! self.localRealm.write {
                    self.deleteImageFromDocumentDirectory(imageName: "\(row._id).png")
                    self.localRealm.delete(row)
                }
            }
            self.tableView.reloadData()
        } editAction: {
            let sb = UIStoryboard(name: "Add", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
            let nav = UINavigationController(rootViewController: vc)
            
            vc.isEditingMode = true
            if self.isFiltering() {
                vc.passedDiary = self.diarySearch[editButton.tag]
            }
            else {
                vc.passedDiary = self.diary[editButton.tag]
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
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
            //return UIScreen.main.bounds.height * 0.7
            return 120
        }
        else {
//            return UITableView.automaticDimension
            return UIScreen.main.bounds.height * 0.7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Table Cell 새로운 디자인 필요 (만들긴 했지만 너무 구림...)
        if isFiltering() {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else {
                return UITableViewCell()
            }
            let row = diarySearch[indexPath.row]
            cell.configureCell(row: row)
            return cell
        }
        
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier) as? MainTableViewCell else {
                return UITableViewCell()
            }
            let row = diary[indexPath.row]
            cell.configureCell(row: row)
            cell.editButton.setTitle("", for: .normal)
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editButtonClicked(editButton:)), for: .touchUpInside)
            if !profile.isEmpty {
                cell.profileImage.image = loadImageFromDocumentDirectory(imageName: "\(profile[0]._id).png")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            let sb = UIStoryboard(name: "Add", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
            let nav = UINavigationController(rootViewController: vc)
            
            vc.isEditingMode = true
            vc.passedDiary = diarySearch[indexPath.row]
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isFiltering() {
            return true
        }
        else {
            return false
        }
    }
    
    //추후에 isFiltering 아닌 경우에는 삭제하는 부분을 아예 지워줘도 될거 같음
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "일기를 삭제", message: "일기를 삭제하겠습니다.", preferredStyle: .alert)
            let del = UIAlertAction(title: "확인", style: .default) { _ in
                //print("메모 삭제를 실행합니다.")

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

