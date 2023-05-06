# 🙋🏻‍♀️나도선배 iOS
![image](https://user-images.githubusercontent.com/63224278/150574516-a8d5f367-968e-48a5-99b8-eb82e4eee9c9.png)
<br>

> **아는 선배 없어도 괜찮아! 우리 같이 서로의 선배가 되어주자!**  
제2전공생을 위한 학과후기, 전공정보 공유 플랫폼 - 나도선배
>
> **29th WE SOPT APPJAM 최우수상 🏆** <br>
> 해커톤 기간 : 2022.01.02 ~ 2022.01.22    
> 앱스토어 출시 : 2022.03.12  
> 사용성 개선 및 기능 확장 업데이트 : 2022.11.05

[<img width=150px src=https://user-images.githubusercontent.com/42789819/115149387-d42e1980-a09e-11eb-88e3-94ca9b5b604b.png>](https://apps.apple.com/kr/app/%EB%82%98%EB%8F%84%EC%84%A0%EB%B0%B0/id1605763068)

<br>

## 🍎 나도선배 iOS Developers
 <img src="https://user-images.githubusercontent.com/63277563/148170419-f698eab4-87e5-4aa9-81ad-5a43fd7f2231.jpg" width="200"> | <img src="https://user-images.githubusercontent.com/63277563/148170415-143c21bb-7c38-42a4-990e-01f0f2db3d6a.png" width="200"> | <img src="https://user-images.githubusercontent.com/63277563/148170409-053650f4-daf0-42db-aa67-d3c3725904f5.png" width="200"> |
 :---------:|:----------:|:---------:|
 🍎 **지은선배** 🍎 | 🍎 **정빈선배** 🍎  | 🍎 **은주선배** 🍎
 [@hwangJi-dev](https://github.com/hwangJi-dev)  |  [@dev-madilyn](https://github.com/dev-madilyn)  |  [@jane1choi](https://github.com/jane1choi)  | 
<br>

## 🛠️ Development Environment
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.0-ff69b4">
<img src ="https://img.shields.io/badge/Xcode-13.3-blue">
<img src ="https://img.shields.io/badge/iOS-15.0-blue">
<br>

## 📚 Library
| 라이브러리(Library) | 버전(Version) | 사용목적(Purpose) |
|:---|:----------|:---|
| SnapKit| 5.0.0 | Layout |
| Then | 3.0.0 | Layout |
| Moya| 15.0.0 | 서버 통신 |
| RxSwift | 6.5.0 | 비동기 처리 |
| RxCocoa | 6.5.0 | 비동기 처리 |
| ReactorKit | 3.2.0 | MVVM 아키텍처 활용 |
| Firebase/Analytics| 9.0.0 | 앱 데이터 분석 |
| Firebase/Messaging| 8.12.0 | 푸시 알림 |
<br>

## ⚙️ 프로젝트 구조
### 🏛️ Architecture: ReactorKit을 활용한 MVVM
<img width="1200" alt="ReactorKit-MVVM" src="https://user-images.githubusercontent.com/63277563/236613006-f9d774e0-be6d-42de-aba2-6899c6fa8c03.png">

### 🗂️ Foldering
```
NadoSunbae-iOS
    ├──📁 Global
    │   ├── LaunchScreen.storyboard
    │   ├── PublicData  
    │   ├── Factory 
    │   ├── Class
    │   ├── Struct
    │   ├── Extension
    │   ├── Protocol
    │   ├── Font
    │   └── UIComponent
    │       ├── Class
    │       └── Xib
    ├──📁 Network
    │   ├── APIEssentials
    │   ├── APIModels
    │   ├── APIManagers
    │   ├── MoyaTarget
    │   └── NetworkLoggerPlugin.swift
    ├──📁 Screen
    │   └── Classroom
    │       ├── Reactor
    │       ├── SB
    │       ├── VC
    │       └── Cell
    └──📁 Support
        ├── AppDelegate.swift
        ├── SceneDelegate.swift
        ├── Assets.xcassets
        ├── Colorsets.xcassets
        ├── Info.plist
        └── Configuration
            ├── Development
            ├── QA
            └── Release
``` 
<br>

## 🎯 주요 기능

### `홈`
### 💡 최신글을 확인할 수 있는 홈 탭

- 서비스 내에서 새로 올라온 모든 글들(후기, 1:1 질문, 커뮤니티 글)을 한눈에 볼 수 있습니다.
- 선배랭킹을 통해 나도선배 서비스에서 열정적으로 활동해주는 선배들을 한눈에 볼 수 있습니다.

<img width="800" alt="호ㅁ" src="https://user-images.githubusercontent.com/63277563/236614624-e9e3db0b-0f27-47b1-85fe-3f466e978402.png">

---
### `과방`
### 💡 학과별 후기를 열람하고 작성할 수 있는 후기 탭

- 본인의 학과 및 관심있는 타학과의 후기글을 열람할 수 있습니다.
- 상단 토글 버튼을 통해 학과 필터 바텀시트를 불러와 열람 학과를 변경할 수 있습니다.
- 본인의 학과 후기를 최소 1회 작성해야 합니다!
    - 학과 후기 작성 항목
        - 필수: 학과의 한줄평, 장단점
        - 선택: 배우는 과목, 추천 수업, 힘든 수업, 향후 진로, 꿀팁 (최소 1개 이상 작성)
	
<img width="900" alt="후기" src="https://user-images.githubusercontent.com/63277563/236615605-03df9895-2df9-4765-ab2c-997adf9c6a3e.png">
<br>


### 💡 후기 작성자와 1:1 질문을 나눌 수 있는 1:1 질문 탭

- 관심있는 학과의 후기를 인상적으로 읽은 후 추가적으로 나누고 싶은 질문이 있다면 1:1 질문 기능을 이용할 수 있습니다.
- 선배의 1:1 질문 목록을 보거나 새 질문을 남길 수 있습니다.
- 질문 기능을 채팅 스레드로 제공합니다.
- 오로지 질문자와, 질문을 받은 사용자만 메시지를 주고받을 수 있으며 일반 유저들은 글 열람만 가능합니다. (답글 작성 불가)
- 부적절한 질문 및 답글은 신고할 수 있으며, 유저를 차단할 수 있습니다. (차단된 유저의 글은 보이지 않습니다.)

<img width="900" alt="11" src="https://user-images.githubusercontent.com/63277563/236615622-fc51a318-57af-4f1e-8dbb-c0da5791e06c.png">

---
### `커뮤니티`
### 💡 자유로운 글을 남기고 소통할 수 있는 커뮤니티 탭

- 커뮤니티 탭에서는 좀 더 자유롭게 유저들간에 소통을 할 수 있습니다.
- 질문/정보/자유 글을 작성하고 소통할 수 있습니다.
    - 특정학과의 전공생 전체에게 혹은 전체학과의 학생들에게 질문하고 싶을 때 커뮤니티의 질문 기능을 이용할 수 있습니다.
    - 질문글을 작성할 때 특정 학과를 지정하면, 해당 학과의 본전공, 제2전공생 모두에게 알림이 갑니다.
- 학과 필터 기능을 통해 특정 학과의 글만을 열람할 수 있습니다.
- 키워드를 통해 게시글을 검색할 수 있습니다.
<img width="900" alt="커뮤" src="https://user-images.githubusercontent.com/63277563/236615638-384e1eac-d8e8-420f-a1c3-bc45257804b9.png">

---
### `알림`
### 💡 나에게 온 알림을 확인할 수 있는 알림 탭

**1:1 질문** 

1. 후배가 1:1질문글 처음 작성시  → 선배에게 알림
2. 작성했던 1:1 질문글에 선배가 답글 달아줬을시. → 후배에게 알림
3. 후배가 본인이 작성한 1:1질문글에 추가 댓글을 다는 경우 → 선배에게 알림

**커뮤니티**

1. 본인이 작성한 커뮤니티글에 댓글이 달린경우 알림
2. 답글을 작성한 커뮤니티 글에 답글이 달린 경우 알림
3. 특정학과대상 질문글이 올라온 경우 알림

<img width="900" alt="알림" src="https://user-images.githubusercontent.com/63277563/236615659-23c72272-c4ae-4e42-9f31-0004f9150d80.png">


---
### `마이페이지`

- 1:1 질문 작성 시 선배의 마이페이지에 질문 글이 게시됩니다.
- 선배의 마이페이지에서는 선배의 본전공, 제2전공, 한줄소개, 질문 응답률 등을 확인할 수 있습니다.
- 본인의 마이페이지인 경우, 프로필을 수정하고 한 줄 소개를 작성할 수 있으며, 내가 쓴 글, 답글, 후기, 좋아요 목록을 모아볼 수 있습니다.

<img width="900" alt="마이" src="https://user-images.githubusercontent.com/63277563/236615666-f2c79d43-62b9-4b09-a840-39b8d73a19b3.png">


</details>
	
<br>

## 💻 Coding Convention
<details markdown="1">
<summary>🖋 네이밍</summary>

---

### Class & Struct
- 클래스/구조체 이름은 **UpperCamelCase**를 사용합니다.

<br>

### 함수, 변수, 상수
- 함수와 변수에는 **lowerCamelCase**를 사용합니다.
- 버튼명에는 **Btn 약자**를 사용합니다.
- 약어를 사용할 경우, 약어는 **대문자**를 사용합니다.
  - 예시

	password -> pw -> **`PW`**
	
	userid -> **`userID`**
- 모든 IBOutlet에는 해당 클래스명을 뒤에 붙입니다.  
  
  <kbd>예외</kbd> Image는 항상 Img로 줄여서 네이밍합니다.
  ```swift
  @IBOutlet weak var settingImgView: UIImageView!
    ```
- 기본 클래스 파일을 생성하거나 컴포넌트를 생성할 때는 약어 규칙에 따라 네이밍합니다.  

  - 예시
     
    `TV` `TVC` `CV` `CVC` `VC` `NVC` `TBC`
    
    ```Swift
    TableView -> TV
    TableViewCell -> TVC
    CollectionView -> CV
    CollectionView Cell -> CVC
    ViewController -> VC
    NavigationController -> NVC
    TabbarController -> TBC
    ```

  <kbd>좋은 예</kbd>
  ```swift
  @IBOutlet weak var nadoBtn: UIButton!
  @IBOutlet weak var nadoBackMainView: UIView!
  @IBOutlet weak var reviewPostTV: UITableView!
  ```
  
  <kbd>나쁜 예</kbd>
  ```swift
  @IBOutlet weak var ScrollView: UIScrollView!
  @IBOutlet weak var nadoCollectionView: UICollectionView!
  @IBOutlet weak var tagCollectionView: UICollectionView!
  @IBOutlet weak var tableview: UITableView!
  ```

<br>

### 함수 네이밍
- `setUp` → setUpDelegate (기능관련 함수)
- `configure` → configureUI (UI관련 함수)   
- `IBAction`→ **tap**DismissBtn() : 단순 클릭, **present**ResultVC() : 화면전환 메소드(push, present, pop, dismiss)

---

</details>

<details markdown="2">
<summary>🏷 주석</summary>
 
---
	
### MARK 주석 

```

// MARK: @IBOutlet

// MARK: Properties

// MARK: @IBAction

// MARK: LifeCycle

// MARK: - UI

// MARK: - Custom Methods

// MARK: - 프로토콜들 하나씩 채택해서 Extension 으로 빼기 (TV, CV, .., Custom Delegate 모두)

/// ~ 하는 메서드 (함수는 항상 문서화)

// TODO: 앞으로 할 일을 TODO로 적어두기
 
```
---
	
</details>

<details markdown="3">
<summary> ⭕️ 공백 </summary>

---
	
- 탭 사이즈는 4로 사용합니다.
- 한 줄의 최대 길이는 80자로 제한합니다.
- 최대 tab depth 제한
  - tab의 최대 depth는 4로 제한합니다.
  - 이 이상으로 depth가 길어지면 함수를 통해 나눌 수 있도록 합니다.
  - 그 이상으로 개선할 수 없다고 판단되는 경우, 팀원들과의 코드리뷰를 통해 개선합니다.  
   
- 괄호 사용
  - (if, while, for)문 괄호 뒤에 한칸을 띄우고 사용합니다.
 
  ```Swift
     if (left == true) {
	   // logic
     }
     ```
  
- 띄어쓰기
 
  ```Swift
  let a = 5; // 양쪽 사이로 띄어쓰기 하기
  if (a == 3) {
	// logic
  }
  ```

---
	
</details>

<details markdown="4">
<summary>🎸 기타규칙</summary>  

---
 
 - 외부에서 사용되지 않을 변수나 함수는 `private`으로 선언합니다.
 - **viewDidLoad()** 와 같은 생명주기 함수들에는 `function`만 위치시킵니다.
 - 불필요한 self는 지양합니다.
     <kbd>예외</kbd> 클로저를 사용할 때는 자체 함수에 self를 붙여줍니다.
 - **Extension** 을 사용해 기능 단위로 코드를 더 가독성있게 구분합니다.

    `<기본 클래스에 배치되는 것>` 
	- IBOutlet, Properties, LifeCycle, IBAction
	
    `<Extension 배치 순서>` 

    ```
    1. UI
    2. custom Methods
    3. delegate (extension으로 빼는 프로토콜들 자유롭게)
    4. 노티, 키보드 등등 
    5. Network
    ```
---
	
</details>

<br>

## ✉️ Commit Convention

```
🔨 Fix: 버그, 오류 해결
✅ Chore: 코드 수정, 내부 파일 수정 등 잡일 모두
➕ Add: Asset 추가, 라이브러리 추가, 새로운 파일 생성
✨ Feat: 새로운 기능 구현
⚰️ Remove: 쓸모없는 코드, 파일 삭제
📝 Docs: README, WIKI 등의 문서 개정
💄 Mod: Storyboard 파일만 수정한 경우
🚚 Move: 프로젝트 내 파일 이동
⏪️ Rename: 파일 이름 변경
♻️ Refactor: 동작 결과는 같으나 코드 자체 전면 수정 및 성능 개선
```

<br>

## ✨Github Management
<details>
<summary> 🙋🏻‍♀️ NadoSunbae-iOS Gitflow 🙋🏻‍♀️ </summary>
<div markdown="1">  

```
1. Issue를 생성한다.
2. feature Branch를 생성한다.
3. Add - Commit - Push - Pull Request 의 과정을 거친다.
4. Pull Request가 작성되면 작성자 이외의 다른 팀원이 Code Review를 한다.
5. Code Review가 완료되면 Pull Request 작성자가 develop Branch로 merge 한다.
6. 종료된 Issue와 Pull Request의 Label과 Project를 관리한다.
```
	
### 🌴 브랜치
---
#### 📌 브랜치 단위
- 브랜치 단위 = 이슈 단위 = PR단위

#### 📌 브랜치명
- 브랜치는 뷰 단위로 생성합니다. (**'UI / Func / Server'** 로 기능 세부 구분)
- 브랜치 규칙 → feature/#이슈번호-(UI/Func/Server)-탭(스크린)-기능간략설명
- `ex) feature/#1-UI-review-makeNaviBar`

<br>
	
### 💡 이슈, PR 규칙
---
#### 📌 Issue명 = PR명
- ✨ [FEAT]
- 🚑️ [HOTFIX]
- 🔨 [FIX]
- ♻️ [REFACTOR]
- ✅ [CHORE]

</details>
<br>
