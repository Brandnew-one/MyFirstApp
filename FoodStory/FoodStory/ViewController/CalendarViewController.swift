//
//  CalendarViewController.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/18.
//

import FSCalendar
import RealmSwift
import UIKit


class CalendarViewController: UIViewController {

  @IBOutlet weak var calendarView: FSCalendar!
  @IBOutlet weak var testLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!

  let localRealm = try! Realm()
  var diary: Results<UserDiary>!
  var eventDiary: Results<UserDiary>!
  var searchDiary: Results<UserDiary>!

  override func viewDidLoad() {
    super.viewDidLoad()
    //        print(#function)

    calendarView.dataSource = self
    calendarView.delegate = self
    calendarView.clipsToBounds = true
    calendarView.layer.cornerRadius = 10

    // 달력의 년월 글자 바꾸기
    calendarView.appearance.headerDateFormat = "YYYY년 M월"
    // 달력의 요일 글자 바꾸는 방법 1
    calendarView.locale = Locale(identifier: "ko_KR")
    // 달력의 요일 글자 바꾸는 방법 2
    calendarView.calendarWeekdayView.weekdayLabels[0].text = "일"
    calendarView.calendarWeekdayView.weekdayLabels[1].text = "월"
    calendarView.calendarWeekdayView.weekdayLabels[2].text = "화"
    calendarView.calendarWeekdayView.weekdayLabels[3].text = "수"
    calendarView.calendarWeekdayView.weekdayLabels[4].text = "목"
    calendarView.calendarWeekdayView.weekdayLabels[5].text = "금"
    calendarView.calendarWeekdayView.weekdayLabels[6].text = "토"

    diary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
    searchDiary = searchSameDay(date: Date())
    testLabel.text = "\(searchDiary.count)개의 일기를 찾았어요"

    let nibName = UINib(nibName: CalendarCollectionViewCell.identifier, bundle: nil)
    collectionView.register(nibName, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.clipsToBounds = true
    collectionView.layer.cornerRadius = 10

    let layout = UICollectionViewFlowLayout()
    let spacing: CGFloat = 8
    let width = UIScreen.main.bounds.width - (spacing * 4)

    layout.itemSize = CGSize(width: width / 3, height: (width / 3 ))
    layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    layout.minimumInteritemSpacing = spacing
    layout.minimumLineSpacing = spacing
    layout.scrollDirection = .horizontal

    collectionView.collectionViewLayout = layout
  }

  //오늘 자 데이터를 추가,삭제 한 경우 바로 반영하기 위해서 추가
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.reloadData()
    calendarView.reloadData()
    testLabel.text = "\(searchDiary.count)개의 일기를 찾았어요"
  }


}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {

  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    //        print("MonthPosition: ",date)
    searchDiary = searchSameDay(date: date)
    testLabel.text = "\(searchDiary.count)개의 일기를 찾았어요"
    collectionView.reloadData()
  }

  //여기서도 searchDiary를 그대로 사용하게 되면 didSelect date 가 달라지기 때문에 터질 수 있다. (일지작성)
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    //        print("numberOfEvent: ",date)
    eventDiary = searchSameDay(date: date)
    return eventDiary.count
  }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchDiary.count
  }


  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
      return UICollectionViewCell()
    }

    let row = searchDiary[indexPath.item]
    cell.collectionImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id).png")
    
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let sb = UIStoryboard(name: "Add", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
    let nav = UINavigationController(rootViewController: vc)

    vc.isEditingMode = true
    vc.passedDiary = searchDiary[indexPath.item]
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true, completion: nil)
  }


}
