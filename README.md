## 🔥 앱 소개

일주일 전 저녁식사 때 어떤 음식을 드셨나요? 바쁜 일상속에 소중한 한끼를 잊으시진 않았나요?
여러분의 소중한 한끼를 기록 해보세요!

| 날짜  | 내용  | 링크 |
| :---: | :---: | :---: |
| 2021.11.16 | 기획안 작성 | [링크](https://github.com/Brandnew-one/MyFirstApp/blob/master/DevLog/2021.11.16/Day1.md) |
| 2021.11.17 | 와이어 프레임 작성 | [링크](https://github.com/Brandnew-one/MyFirstApp/blob/master/DevLog/2021.11.17/Day2.md) |
| 2021.11.18 | 뷰 구현 | [링크](https://github.com/Brandnew-one/MyFirstApp/blob/master/DevLog/2021.11.18/Day3.md) |
| 2021.11.19 ~ 2021.11.20 | 테이블뷰 삭제 및 수정, 서치기능  |[링크](https://github.com/Brandnew-one/MyFirstApp/blob/master/DevLog/2021.11.19%7E20/Day4%7E5.md) |
| 2021.11.21 | 서치 테이블뷰 수정, 코드 리팩토링 | [링크](https://github.com/Brandnew-one/MyFirstApp/blob/master/DevLog/2021.11.21/Day6.md) |
| 2021.11.22 | FSCalendar 이벤트, 컬렉션 뷰 추가 및 수정 | [링크](https://github.com/Brandnew-one/MyFirstApp/blob/master/DevLog/2021.11.22/Day7.md) |
| 2021.11.23 | SettingView 구현 및 앱 컬러 설정| [링크](https://github.com/Brandnew-one/MyFirstApp/blob/master/DevLog/2021.11.23/Day8.md) |
| 2021.11.24 | 백업/복구기능, 앱아이콘 제작 | [링크](https://github.com/Brandnew-one/MyFirstApp/blob/master/DevLog/2021.11.24/Day9.md) |



## 출시 프로젝트 기획 항목

<img width="970" alt="스크린샷 2021-11-16 오후 10 13 56" src="https://user-images.githubusercontent.com/88618825/141991761-49d3fc80-f95c-4691-ae9b-fa7279d2d94c.png">


#### `11/18(목)~11/21(일)`
| 이터레이션2 | 예상 구현시간 | 실제 구현 여부 | 이슈 |
| :---: | :---: | :---: | :---: |
| 외부 폰트 추가(+복습) | 1.5h | - | - |
| 스토리보드/ 뷰컨트롤러 화면전환 구현 | 3h | v | 1차적으로 만든 디자인이 너무... 모든 기능을 구현뒤에 디자인을 따로 손보는 과정 필요|
| 등록 뷰에 ImagePicker, PHpicker 학습 및 추가 | 3h | v | - |
| 홈 뷰 `UI(테이블뷰/셀/오토레이아웃)` | 2h | v | - |
| 데이터베이스 스키마 구조 | 2h | v | 사용자 프로필 사진만 따로 저장하는 데이터베이스를 하나 만들어야 한다. |
| Document에 사용자가 등록하 사진 저장되도록 설정 | 1.5h | v | - |
| 홈 뷰 테이블뷰에 Realm 연동 | 2h | v | - |
| Search Controller 복습 | 2h | v | - |
| 홈 뷰 Search Controller 연결 | 1h | v | - |
| 홈 뷰 Search Controller 분기처리 `(동일View)` | 4h | v | - |
| 달력 뷰 FSCalendar 학습 및 연결 | 2h | v | - |

#### `11/22(월)~11/24(수)`
| 이터레이션3 | 예상 구현시간 | 실제 구현 여부 | 이슈 |
| :---: | :---: | :---: | :---: |
| 달력 뷰 `UI(컬렉션뷰/셀/오토레이아웃)` | 2h | 2h | - |
| 달력 뷰 사용자 선택 날짜에 따른 결과 나오도록 설정 | 4h | 3h | 선택한 날짜를 필터링 하는데 조금 애를 먹었다. 자세한 내용은 22일 일지 |
| 달력 뷰에서 추가화면으로 넘어왔을 때 분기처리 | 3h | 1.5h | 1차 스프린트에서 분기처리를 미리 해놔서 편했다. |
| 홈 뷰에 didSelect 에서 수정 할 수 있도록 분기처리 | 3h | - | - |
| 홈 뷰 Swipe Action 을 통해서 삭제 설정 | 3h | 1.5h | swipe를 통해서 삭제가 어색하다는 평이 많아서, 버튼을 통해 액션얼럿을 띄워서 삭제하도록 변경 예정 |
| 설정 뷰 `UI(테이블뷰/셀/오토레아웃)` | 2h | 4h | 추가적인 view 를 구성해야 하는 이슈가 발생해 시간이 좀 걸렸다. |

#### `11/25(목)~11/28(일)`
| 이터레이션4 | 예상 구현시간 | 실제 구현 여부 | 이슈 |
| :---: | :---: | :---: | :---: |
| 설정 뷰 백업 기능 구현하기 | 3h | 3h | 백업, 복구 자세하게 블로그에 정리 필요 |
| 설정 뷰 복구 기능 구현하기`(+학습)` | 5h | 1.5h | 우선은 빠르게 구현만 한 상태 |
| 버그 픽스 | - h | - | - |
| 코드 리팩토링 | 6h | - | - |
| 앱 출시 사전 준비(+학습 및 기록) | 6h | - | - |

