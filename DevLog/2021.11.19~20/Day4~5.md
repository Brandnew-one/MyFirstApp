1 ) 추가화면 구성 및 Realm 연동

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-20 at 20 48 13](https://user-images.githubusercontent.com/88618825/142725237-3c61244e-4849-4aae-99cb-bce00b307cab.gif)


2 ) PHPicker 를 이용해 앨범에서 사진을 선택하고 저장하도록 설정

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-20 at 20 50 13](https://user-images.githubusercontent.com/88618825/142725290-d50254c9-1260-47e5-898d-e7807e5e261a.gif)


3 ) 테이블뷰 수정기능

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-20 at 20 51 32](https://user-images.githubusercontent.com/88618825/142725317-45e729d7-87c9-4750-b198-568e773544dd.gif)


4 ) Search 기능 (+수정)

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-20 at 20 59 04](https://user-images.githubusercontent.com/88618825/142725506-50e13b14-9c22-4141-9882-bd231b038c8d.gif)

5) 삭제기능 (스와이프 삭제가 불편하다는 주변 사람들의 피드백이 있어서 수정해볼 예정)

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-20 at 21 01 41](https://user-images.githubusercontent.com/88618825/142725564-a1fb1f14-7096-47b8-865c-39cf8f882f94.gif)

***

## 개발 이슈

1 )
Search 기능에서 지난주 메모를 구현 할 때는 현재 테이블뷰의 indexPath.row 값만을 가져가서 Realm 의 데이터를 호출하고 해당하는 Row 값을 이용해 데이터에 접근했다. 

하지만 `Object` 자체를 passData 로 설정하면 object_ID 값도 존재하기 때문에 Realm 에서 몇번째 인덱스에 저장되어 있는지 신경쓰지 않고 좀 더 편하게 데이터를 수정할 수 있었다ㅠㅠ



2 )
사진의 경우 object_ID 를 파일명으로 이용해서 저장하는 방법을 사용한다. 그리고 추후에 데이터 백업/복구를 위해서 도큐먼트에 바로 저장하는게 아닌 폴더를 하나 만들어서 저장하는 형태로 구현했다.
`(잭님의 피드백이 없었다면 다음주에 광광 울었다)`

```swift
guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let filePath = documentDirectory.appendingPathComponent("Image")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let imageURL = filePath.appendingPathComponent(imageName)
```

Swift 5.x 부터는 디렉토리를 추가하는 과정은 위와 같이 작성해야 한다.


3 ) Slider 구현

[블로그](https://iamcho2.github.io/2021/06/22/make-star-rating-view) 를 보고 구현했습니다.

