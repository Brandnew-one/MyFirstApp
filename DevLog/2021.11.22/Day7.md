#### 1 ) FSCalendar 이벤트 구현 - `3.5h`

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-23 at 00 04 53](https://user-images.githubusercontent.com/88618825/142884821-dd358c36-29ac-4037-ac75-6512be83ab80.gif)

사용자가 선택한 날짜를 기준으로 Realm 에서 필터링을 하는 과정에서 생각보다 시간이 오래 걸렸다.

FSCalendar 에서 날짜를 고르면 yyyy:MM:dd 뿐만 아니라 시간까지 나오기 때문에 시간을 검색 범위에서 제외하는 과정이 필요했다.

```swift
func searchSameDay(date: Date) -> Results<UserDiary> {
        let localRealm = try! Realm()
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        
        //Date 형식을 바로 포맷 적용하는 메서드는 없을까?
        let refDate = Date(timeInterval: (60*60*24), since: date) //선택한 다음날을 기준으로 설정
        
        //Date를 포맷을 적용한 String 으로 변경
        let stringPickDate = format.string(from: date)
        let pickDate = format.date(from: stringPickDate)
        
        //포맷이 적용된 String 를 다시 Date 로 변경
        let stringRefDate = format.string(from: refDate)
        let pickRefDate = format.date(from: stringRefDate)
        
        let search = localRealm.objects(UserDiary.self).filter("writeDate >= %@ AND writeDate < %@ ",pickDate, pickRefDate)
        return search
    }
```

어떻게 구현할까 하다가 사용자가 검색한 날짜를 기준으로 24시간이 지난 다음날을 잡고 그 두 날 사이에 있는 값들을 필터링 하도록 설정했다.

`+ 여기서 Date 타입을 바로 데이트포맷으로 적용하는 메서드를 찾지 못해서 Date 타입을 String 타입으로 바꾸고 다시 Date 타입으로 바꿔서 구현했다...`
`+ 최대한 코드를 깔끔하게 작성하기 위해서 RealmQuery 파일을 만들어서 필터링 함수를 따로 정의했다.`

***

#### 2 ) CollectionView didSelectItemAt - `1.5h`

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-23 at 00 57 30](https://user-images.githubusercontent.com/88618825/142893756-18984cbe-1a95-4dac-b4c6-2009c4ba8bc2.gif)

컬렉션뷰에서 사용자가 선택한 날짜를 기반으로 해당날짜에 작성한 일기들을의 이미지를 컬렉션뷰에 띄워주고, 아이템을 터치할 경우 수정하면으로 넘어갈 수 있도록 구현했다.

`디자인은 우선 기능 구현을 마치고 대대적으로 손보기로 했다!`
