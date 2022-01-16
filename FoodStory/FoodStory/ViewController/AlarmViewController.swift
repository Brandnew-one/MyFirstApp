//
//  AlarmViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/12/06.
//

import RealmSwift
import NotificationCenter
import UserNotifications
import UIKit

class AlarmViewController: UIViewController {
    
    let alarmList = ["아침", "점심", "저녁"]
    var localRealm = try! Realm()
    var localNotificationList: Results<UserNotification>!
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    
    @IBOutlet weak var totalAlarmView: UIView!
    @IBOutlet weak var totalAlarmLabel: UILabel!
    @IBOutlet weak var totalAlarmSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAlarmDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        //사용자로부터 권한을 받도록 하는 설정
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotificationCenter.requestAuthorization(options: authorizationOptions) { didAllow, error in
            if didAllow {
                print("사용자가 권한설정을 허용했습니다.")
                DispatchQueue.main.async {
                    self.totalAlarmSwitch.isEnabled = true
                }
            }
            else {
                print("사용자가 권한 설정을 허용하지 않았습니다.")
                self.authorizationAlert(title: "설정으로 이동", message: "알림권한 허용해주세요\n권한을 허용하지 않으면 알림을 받을 수 없습니다.", okTitle: "설정으로 가기") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url) { success in
                                print("잘 열렸다. \(success)")
                            }
                        }
                    }
                    
                }
                DispatchQueue.main.async {
                    self.totalAlarmSwitch.isOn = false
                    self.tableView.isHidden = true
                    self.totalAlarmSwitch.isEnabled = false
                }
            }
            
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        totalAlarmView.clipsToBounds = true
        totalAlarmView.layer.cornerRadius = 10
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "알림"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        totalAlarmLabel.text = "전체알림"
        totalAlarmDescription.text = "알림을 비활성화 하시면 설정한 알림이 동작하지 않습니다."
        
        isFirstOpen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    func isFirstOpen() {
        //0(전체설정), 1(아침) , 2(점심), 3(저녁)
        localNotificationList = localRealm.objects(UserNotification.self).sorted(byKeyPath: "userIndex", ascending: true)
       
        //최초화면 접근 시 임의 값으로 넣어준다.
        if localNotificationList.isEmpty {
            var task = UserNotification(userIndex: 0, userSettingTime: nil ,userSettingisOn: false)
            try! localRealm.write {
                localRealm.add(task)
            }
            for i in 1...3 {
                task = UserNotification(userIndex: i, userSettingTime: Date() ,userSettingisOn: false)
                try! localRealm.write {
                    localRealm.add(task)
                }
            }
            totalAlarmSwitch.isOn = localNotificationList[0].userSettingisOn
            tableView.isHidden = true
            totalAlarmDescription.isHidden = false
        }
        //최초접근이 아닌경우, 저장된 값에 따라서 화면을 출력해준다.
        else {
            totalAlarmSwitch.isOn = localNotificationList[0].userSettingisOn
            //전체 설정이 켜져있는 경우
            if localNotificationList[0].userSettingisOn {
                totalAlarmDescription.isHidden = true
                tableView.isHidden = false
            }
            else {
                totalAlarmDescription.isHidden = false
                tableView.isHidden = true
            }
        }
    }
    
    @IBAction func totalAlarmSwitchClicked(_ sender: UISwitch) {
        if sender.isOn {
            let taskToUdate = localNotificationList[0]
            print(sender.isOn)
            try! localRealm.write {
                taskToUdate.userSettingisOn = sender.isOn
            }
            for i in 1...3 {
                let row = localNotificationList[i]
                let userNoti = LocalNotification(id: row._id, date: row.userSettingTime!, isOn: row.userSettingisOn)
                userNotificationCenter.addNotificationRequest(by: userNoti)
            }
            totalAlarmDescription.isHidden = true
            tableView.isHidden = false
        }
        else {
            let taskToUdate = localNotificationList[0]
            print(sender.isOn)
            try! localRealm.write {
                taskToUdate.userSettingisOn = sender.isOn
            }
            for i in 1...3 {
                userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [localNotificationList[i]._id.stringValue])
            }
            totalAlarmDescription.isHidden = false
            tableView.isHidden = true
        }
    }
    
    @objc
    func closeButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        
        cell.alarmLabel.text = alarmList[indexPath.row]
        cell.alarmSwitch.isOn = localNotificationList[indexPath.row + 1].userSettingisOn
        cell.timeLabel.text = timeToString(nowDate: localNotificationList[indexPath.row + 1].userSettingTime!)
        cell.alarmSwitch.tag = indexPath.row + 1
        cell.configureCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "SettingAlarm", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SettingAlarmViewController") as! SettingAlarmViewController
        vc.passedNotification = self.localNotificationList[indexPath.row + 1]
        vc.pickedDate = { [weak self] date in
            guard let self = self else { return }
            if self.localNotificationList[indexPath.row + 1].userSettingisOn {
                let row = self.localNotificationList[indexPath.row + 1]
                let userNoti = LocalNotification(id: row._id, date: row.userSettingTime!, isOn: row.userSettingisOn)
                self.userNotificationCenter.addNotificationRequest(by: userNoti)
            }
            self.tableView.reloadData()
        }
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "알림설정"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

extension AlarmViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
