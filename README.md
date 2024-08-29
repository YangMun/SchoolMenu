# 프로젝트 진행 일지

### 1일차 (Day 1)
- **주요 작업**:
  - `MainSelectView` UI 레이아웃 및 디자인
    - SwiftUI를 사용하여 메인 선택 화면(MainSelectView) 구현.
    - 배경 이미지와 오버레이 추가로 시각적으로 매력적인 레이아웃 구성.
    - 푸드코트, 교직원 식당, 맛도리 랭킹으로의 네비게이션 버튼 디자인.
   
  - 네비게이션 및 흐름
    - `ContentView`, `TeacherMenuView`, `Top10View`로의 원활한 화면 전환을 위한 NavigationLink 구현.

### 2일차 (Day 2)
- **주요 작업**:
  -`ContentView` UI 구성 및 디자인
    - 카테고리별 메뉴를 TabView로 표시.
  -`TeacherMenuView` UI 구성 및 디자인
    - 카테고리별 메뉴를 TabView로 표시.

### 3일차 (Day 3)
- **주요 작업**:
  -`ContentView`, `TeacherMenuView`에 대한 기능 함수 정의
    - SwiftSoup 패키지를 이용해 웹 스크래핑 하여 저장
    - 가공된 데이터를 각 뷰에 전달
 
### 4일차 (Day 4)
- **주요 작업**:
  - Firebase 연동
    - FireStore를 통해 초기 구조 생성
    - 메뉴 데이터에 대한 기능을 함수로 정의 (매일 1번 실행)
    
### 5일차 (Day 5)
- **주요 작업**:
  - `VoteView` UI 레이아웃 및 디자인
    - FireStore에 저장된 데이터 화면에 띄워주기
    - 투표 버튼 기능 구현
    
### 6일차 (Day 6)
- **주요 작업**:
  - `Top10View` UI 레이아웃 및 디자인
    - FireStore에 저장된 메뉴에 대해 투표 수 Top 10 기능 구현
    - 실시간으로 데이터 변경에 대한 UI 구현

### 7일차 (Day 7)
- **주요 작업**:
  - GoogleAdmob 적용
    - 각 배너에 필요한 기능 구현

### 9일차 (Day 9)
- **주요 작업**:
  - `LoadingView`, `AppStartView` 추가
    - `LoadingView`: 앱 시작시 로딩 화면
    - `AppStartView`: 메인 화면의 데이터가 준비 되면 다음 로직을 수행하도록 연결 다리 작업
  
### 10일차 (Day 10)
- **주요 작업**:
  - v1.3.2 버전 업그레이드
  - checkAndUpdateMenu() -> return 추가하여 로직을 빠져 나오게 해야 함
   

## To-Do List
- [ ] 데이터 흐름 파악하여 유지 보수(계속)
- [x] Firebase 구현하기
- [ ] 실시간 데이터 변경에 따른 오류 수정
- [x] 최신 데이터 업데이트 됐지만 신규 사용자가 앱을 열면 모든 데이터가 다시 업데이트 되어 신규 사용자는 업데이트 X
