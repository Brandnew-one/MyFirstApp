## 업데이트

토요일에 앱 스토에 앱이 출시되고 안도감에 며칠을 쉬었다.... 공부를 안한건 아니지만 뭔가 집중해서 계획한 업데이트 내용들을 만들지 못했다...

아직까지 남들에게 한번 써보라고 권유하기 부끄럽기 때문에 이왕 출시한거 내 나름대로 최선을 다해서 업데이트 해보려고 한다.🔥🔥🔥🔥

우선, 계획한 업데이트 내용은 이렇다.

| 업데이트 | 상세내용  |
| :-: | :-: |
| Local Notification 추가 | 사용자가 아침,점심,저녁 시간을 설정하면 해당하는 시간에 알림을 줄 예정이다 |
| 추가 및 수정화면에 Scroll View 사용 | 같은 팀원인 혜진님의 블로그를 참고해서 추가해볼 예정 |
| 가격을 기입할 수 있도록 설정 | 데이터 베이스 스키마 변경이 필요하기 때문에 마이그레이션 학습 후 적용 예정 |

우선은 위의 3가지 정도를 목표로 업데이틑 할 예정이고, 마이그레이션 작업이 완료되는 대로 앱에 통계탭을 추가할 예정이다.

***

## Local Notification

주말을 이용해서, Local Notification 에 대하 학습을 어느정도 진행했는데 내 앱에 바로 녹이는데 까지 시간이 좀 오래 걸렸다..

| 알림설정 | 알림 |
| :-: | :-: |
| ![Simulator Screen Recording - iPhone 13 Pro - 2021-12-10 at 00 01 35](https://user-images.githubusercontent.com/88618825/145420902-6a23f1ae-42c3-4c07-a4cf-f447108b9ecc.gif) | ![Simulator Screen Recording - iPhone 13 Pro - 2021-12-10 at 00 02 04](https://user-images.githubusercontent.com/88618825/145420971-8ba9d456-c90f-48e0-a8c5-c414d45bf091.gif) |

학습한 내용은 custom 한 자료형의 UserDefaults 를 사용했는데, 어려워서 `Realm` 을 이용했다..... (아직 전체 알람끄기는 구현하지 않은 상태)

구현하면서 몇 가지 시행착오가 있었다.

***

#### 1) AlarmView -> SettingAlarmView 로 넘어가서 시간을 설정하고 돌아올 때, AlarmView에 값으 어떻게 넘겨줄 것인가?

다음화면으로 값 전달하는 경우는 많이 해봤지만 반대로 이전화면으로 다시 값을 전달하는 경우느 별로 없었다.

그런 경우에는 모두 `ViewWillAppear()` 를 통해서 값을 갱신해줬었는데, 오늘은 `presentModal` 방식을 통한 화면전환 이였기 때문에 `ViewWillAppear()` 를 사용할 수 없었다.

* 클로저를 이용
* Notification 을 활용

두 가지 방법을 통해서 해결이 가능했다. 수업시간에 후자으 방법을 한 번 다뤘었던것 같은데 기억이 가물가물해서 첫번째 방법을 이용했다.
```swift
var pickedDate: ((_ date: Date) -> Void)?

@IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        let taskToUpdate = passedNotification
        try! localRealm.write {
            taskToUpdate.userSettingTime = datePicker.date
        }
        pickedDate?(self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
```


문제를 해결하긴 했는데 좀 더 학습이 필요할 것 같다. 블로그에 따로 정리해야겠다.

***

#### 2) 사용자가 권한을 허용하지 않은 경우

사용자가 권한 설정을 허용하지 않은 경우에는 설정 탭으로 갈 수 있도록 설정했다. 그리고 설정탭에서 사용자가 권한을 허용하지 않을 것을 대비해 전체 알람 스위치를 비활성화 시켰다.

그런데 사용자가 권한 설정을 허용한 경우, 알림 설정화면을 나갔다가 다시 들어와야 해당 로직이 적용된다.

즉, 앱을 사용하다 다른앱으로 갔다가 다시 돌아올때에 대한 분기처리를 해줘야 하는데 학습이 좀 필요할것 같다.

***

금방 구현할거라고 생각했는데 생각보다 삽질을 많이 했다.

처음에는 SettingAlarmView 를 만들지 않고, AlarmView 의 `tableCell` 에 datePicker 를 넣어서 바로 구현하려고 했었는데 언제 알림 설정을 했는가? 를 처리해주기 굉장회 까다워서 포기했다.
`(왜 애플기본앱이나 다른앱에서 알림 설정하는 탭이 따로 있는지 깨달았다.)`


내일 빨리  자잘한 것들 마무리해서 디자인 좀 손봐야할것 같다
