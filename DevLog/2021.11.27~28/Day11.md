#### 1 ) 달력에서 작성한 일기 미리 확인하기

![Simulator Screen Recording - iPhone 13 Pro - 2021-11-28 at 21 26 57](https://user-images.githubusercontent.com/88618825/143767710-62cec710-d6c1-4071-a1dd-d85f83194d71.gif)

먼저 달력에서 날짜를 선택했을 때와 오늘 날짜를 보여주는 색깔을 앱의 전체적인 분위기를 맞춰보았다..`(나만 그렇게 느낄수도..)`

그리고 날짜를 클릭하기 전에는 작성한 일기가 있는지 없는지 확인 할 수 없기 때문에 event 를 날짜 밑에 띄워주도록 설정했다.

```swift
func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        print("numberOfEvent: ",date)
        eventDiary = searchSameDay(date: date)
        return eventDiary.count
    }
```

`*주의`

구현 자체는 이전에 구현한 선택한 날짜가 오늘 날짜인지를 기준으로 필터링 한 결과를 가져오면 되기 때문에 쉬웠지만, didSelect 와 동일한 오브젝트 파일을 사용하게 되면
처음 달력탭으로 왔을 때의 날짜와 numberofEvent 에 의한 날짜가 다르기 떄문에 앱이 터지는 문제가 발생할 수 있다.

<img width="338" alt="스크린샷 2021-11-28 오후 9 32 57" src="https://user-images.githubusercontent.com/88618825/143767910-0c42f1df-9ebf-4183-a6f8-8b2d144720cd.png">

그래서, numberOfEvent 함수와 didselect 함수에서의 Realm 오브젝트 파일을 다르게 설정했다!

#### 2) 텍스트 뷰 y축 정렬

![Simulator Screen Recording - iPhone 13 Pro - 2021-11-28 at 21 35 44](https://user-images.githubusercontent.com/88618825/143768006-4594e3cf-f768-4213-b61c-6b0e2d10731c.gif)

구글링을 통해서 y축 가운데 정렬을 하도록 설정했으나 동일하게 위로 치우치게 나왔다.. 일단 textView 높이를 낮춰서 title 과 높이를 맞추는 방향으로 해결했다.

출시전에 좀 더 찾아보고 방법을 알게되면 수정해야겠다.


***

내일은 
* 이미지를 저장할 때, 이미지를 리사이징해서 용량을 줄일 수 있도록 설정하기
* 작성한 내용의 일기가 길 경우, didselectRowAt `OR` 별도의 버튼을 이용해서 일기 내용 show 하기

2가지를 구현하고 앱 출시 준비를 본격적으로 시작할 것 같다.
