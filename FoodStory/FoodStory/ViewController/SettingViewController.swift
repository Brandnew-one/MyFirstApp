//
//  SettingViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import UIKit

class SettingViewController: UIViewController {
    
    let settingImage: [String] = ["speaker.fill",  "tray.fill", "tray.and.arrow.down.fill"]
    let settingString: [String] = ["공지사항", "백업", "복구"]
    
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
    
    
}
