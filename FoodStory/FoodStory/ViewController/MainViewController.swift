//
//  MainViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import UIKit

import RealmSwift
import Firebase

enum MainViewMode {
  case search
  case none
}

class MainViewController: UIViewController {

  var searchController: UISearchController!
  var localRealm = try! Realm()
  var diary: Results<UserDiary>!
  var diarySearch: Results<UserDiary>!
  var profile: Results<Userprofile>!

  @IBOutlet weak var tableView: UITableView!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupRealm()
    tableView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupSearchBar()
    setupNaviView()
    setupRealm()
  }

  private func setupTableView() {
    let nibName = UINib(nibName: MainTableViewCell.identifier, bundle: nil)
    let nibSearch = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: MainTableViewCell.identifier)
    tableView.register(nibSearch, forCellReuseIdentifier: SearchTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
  }

  private func setupNaviView() {
    self.navigationItem.searchController = searchController
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationItem.title = "Foodie Story"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "plus"),
      style: .plain,
      target: self,
      action: #selector(addButtonClicked)
    )
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x3F674C)
  }

  private func setupRealm() {
    diary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
    profile = localRealm.objects(Userprofile.self)
  }

  private func setupSearchBar() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.placeholder = "Search"
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.searchBar.tintColor = UIColor(rgb: 0x3F674C)
  }

  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }

  func isFiltering() -> MainViewMode {
    if searchController.isActive && !searchBarIsEmpty() {
      return .search
    } else {
      return .none
    }
  }


  // MARK: - AddVC랑 같이 바꿔야 함
  @objc
  func addButtonClicked() {
    let sb = UIStoryboard(name: "Add", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
    //    self.navigationController?.pushViewController(vc, animated: true)
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true, completion: nil)
  }

  @objc
  func editButtonClicked(editButton: UIButton) {
    removableActionSheet(
      deleteAction: {
        let row = self.diary[editButton.tag]
        try! self.localRealm.write {
          self.deleteImageFromDocumentDirectory(imageName: "\(row._id).png")
          self.localRealm.delete(row)
        }
        self.tableView.reloadData()
      }, editAction: {
        let sb = UIStoryboard(name: "Add", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        let nav = UINavigationController(rootViewController: vc)

        vc.isEditingMode = true
        vc.passedDiary = self.diary[editButton.tag]
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }
    )
  }
}


extension MainViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    let predicate = NSPredicate(
      format: "foodTitle CONTAINS[c] %@ OR foodMemo CONTAINS[c]  %@",
      text as CVarArg,text as! CVarArg
    )
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
    switch isFiltering() {
    case .search:
      return diarySearch.count
    case .none:
      return diary.count
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch isFiltering() {
    case .search:
      return 120
    case .none:
      return UIScreen.main.bounds.height * 0.7
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch isFiltering() {
    case .search:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else {
        return UITableViewCell()
      }
      let row = diarySearch[indexPath.row]
      cell.configureCell(row: row)
      return cell

    case .none:
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
    if isFiltering() == .search {
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
    switch isFiltering() {
    case .search:
      return true
    case .none:
      return false
    }
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
      let alert = UIAlertController(title: "일기를 삭제", message: "일기를 삭제하겠습니다.", preferredStyle: .alert)
      let del = UIAlertAction(title: "확인", style: .default) { _ in
        switch self.isFiltering() {
        case .search:
          let row = self.diarySearch[indexPath.row]
          try! self.localRealm.write {
            self.deleteImageFromDocumentDirectory(imageName: "\(row._id).png")
            self.localRealm.delete(row)
          }
        case .none:
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

      self.present(alert, animated: true)
      success(true)
    })
    deleteAction.backgroundColor = .systemRed
    return UISwipeActionsConfiguration(actions:[deleteAction])
  }
}

