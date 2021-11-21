### 1 ) FSCalendar 추가 및 간단한 예제 공부

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-21 at 21 40 03](https://user-images.githubusercontent.com/88618825/142762179-ac103acf-3ae3-480d-a743-296a6449dba7.gif)


### 2 ) 코드 리팩토링

지난주 과제 피드백을 받고 지금 프로젝트도 중복된 메서드들이 많고, Extension 을 사용하지 않고 있다는 것을 깨달았다. <p>
코드 정리를 더 미루다간 미래의 내가 너무 힘들어질 것 같아 정리하는 시간을 가졌다.

- Document 에 접근하는 메서드들을 Extension 으로 처리 `(해당 과정에서 UIViewController, UITableViewCell 모두 필요한 메서들의 경우도 한번에 처리할 수 있는 방법이 있을까?)`
- cellForRowAt 에서 반복되는 부분은 Cell 클래스 파일에서 작성

### 3 ) Search TableViewCell 디자인

![Simulator Screen Recording - iPhone SE (2nd generation) - 2021-11-21 at 21 37 34](https://user-images.githubusercontent.com/88618825/142762102-656784f9-ab64-4c31-bce0-d893059f3475.gif)

수정했지만 사실 여전히 구리다.. 내 미적감각은 진짜 최악이라는 것을 느꼈다..

