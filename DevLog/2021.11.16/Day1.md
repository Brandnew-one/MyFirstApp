# 1차 스프린트


## 스프린트 목표

- [ ]  앱 소개
- [ ]  기획안 작성
- [ ]  UI 구조 설계
- [ ]  애플 개발자 계정 결제
- [ ]  데이터베이스 스키마

---

## 🔥 앱 소개

일주일전 저녁은 무엇을 드셨나요?  기억 나시나요? 

여러분들의 한끼 식사를 기록해보세요!

---

## 🔨 Base Line

![Untitled](https://user-images.githubusercontent.com/88618825/142005808-6d4af285-bda9-4fbf-9429-4fdc35d6d28a.png)

대략적인 앱의 구조는 위의 그림과 같습니다.

## 화면구성

- 홈화면 UI (Table View 와 SearchController)
- 달력 UI(달력(?) 과 선택한 날짜에 따른 데이터를 Collection View 를 통해서 보여줄 예정)
- 설정 UI (Table View)
- 등록 UI

## 기능

- 홈화면에서 Search 기능을 통해서 사용자가 입력한 데이터에 해당하는 Cell 을 보여줌
- 달력화면에서 사용자가 선택한 날짜에 해당하는 정보를 Collection view 를 통해서 보여줌
- 설정화면에서 현재 사용자가 저장한 데이터를 백업 및 복구 할 수 있도록 설정

---



## 목표를 달성하기 위해 노력했던 것들, 알게된 지식들

초기에는 메인뷰에서 TableView 안에 CollectionView 를 넣어주는 형태로 구성하려고 했으나 Search 기능을 통해서 CollectionView item 을 보여줘야 할까? 아니면 해당 item이 포함된 TableView Cell 을 보여줘야 할까하는 의문이 생겼다.

그리고 메인화면에서 날짜별로 너무 많은 TableView Cell 이 보여지게 되면 사용자 관점에서 가독성이 떨어질것 같아 아예 TableView 만 넣는 것으로 변경했다.

추가화면에서 사용자의 갤러리에 접근하는 ImagePicker, PHPicker 2가지를 버전에 따라 대응할지 고민중이다.

---



## 다음 스프린트를 위한 새로운 마음가짐

열심히 하겠습니다..

---
