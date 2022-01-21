# 🙋🏻‍♀️나도선배 iOS
![Frame 14](https://user-images.githubusercontent.com/63224278/149148867-674514b9-1eec-4b91-9e5d-9fc6b8d3dfa1.png)
![image](https://user-images.githubusercontent.com/63224278/150574516-a8d5f367-968e-48a5-99b8-eb82e4eee9c9.png)
<br>

> **아는 선배 없어도 괜찮아! 우리 같이 서로의 선배가 되어주자!**  
제2전공생을 위한 학과후기, 전공정보 공유 플랫폼 - 나도선배
>
> 29th WE SOPT APPJAM <br>
> 프로젝트 기간 : 2022.01.02 ~ 2021.01.22

<br>

## 🍎 나도선배 iOS Developers
 <img src="https://user-images.githubusercontent.com/63277563/148170419-f698eab4-87e5-4aa9-81ad-5a43fd7f2231.jpg" width="200"> | <img src="https://user-images.githubusercontent.com/63277563/148170415-143c21bb-7c38-42a4-990e-01f0f2db3d6a.png" width="200"> | <img src="https://user-images.githubusercontent.com/63277563/148170409-053650f4-daf0-42db-aa67-d3c3725904f5.png" width="200"> |
 :---------:|:----------:|:---------:|
 🍎 **지은선배** 🍎 | 🍎 **정빈선배** 🍎  | 🍎 **은주선배** 🍎
 [@hwangJi-dev](https://github.com/hwangJi-dev)  |  [@dev-madilyn](https://github.com/dev-madilyn)  |  [@jane1choi](https://github.com/jane1choi)  | 
<br>

## 🌲 Menu Tree 
![menuTree](https://user-images.githubusercontent.com/58043306/150113629-9e7c325b-d7b6-429d-9134-11a9d2de4c0c.png)
<br>


## 📋 IA  
![nadosunbaeIA수정본](https://user-images.githubusercontent.com/58043306/150135580-ceca346c-fe48-4724-a83f-c395bef71db3.jpg)
<br>
<br>

## 💻 Coding Convention
<details markdown="1">
<summary>🖋네이밍</summary>

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
<summary>🏷주석</summary>
 
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
<summary>⭕️공백</summary>

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
<summary>🎸기타규칙</summary>  

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
	

## 🗂 Foldering Convention
<details>
<summary> 🙋🏻‍♀️ NadoSunbae-iOS Foldering Convention 🙋🏻‍♀️ </summary>
<div markdown="1"> 

```

 NadoSunbae-iOS
    ├──📁 Global
    │   ├── LaunchScreen.storyboard
    │   ├── Class
    │   ├── Extension
    │   ├── Factory 
    │   ├── Font
    │   ├── Protocol
    │   ├── Struct
    │   └── UIComponent
    │       ├── Class
    │       └── Xib
    ├──📁 Network
    │   ├── APIEssentials
    │   ├── APIModels
    │   ├── APIServices
    │   ├── MoyaTarget
    │   └── NetworkLoggerPlugin.swift
    ├──📁 Screen
    │   └── Classroom
    │       ├── SB
    │       ├── VC
    │       └── Cell
    └──📁 Support
        ├── AppDelegate.swift
        ├── Assets.xcassets
        ├── Colorsets.xcassets
        ├── Info.plist
        └── SceneDelegate.swift
``` 
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
	
### 🙆🏻‍♀️ 역할 분담 선배
---
- 지은
```
- 과방 탭
- 프로젝트 세팅
- 공통 컴포넌트: NadosunbaeBtn, NodosunbaeNaviBar, NadosunbaeTextView, NadoSegmentView, NadoHorizonContainerViews
```

- 은주
```
- 후기 탭
- 공통 컴포넌트: 학과 선택 bottom sheet
```

- 정빈
```
- 로그인, 회원가입, 알림 탭, 마이페이지 탭
- FCM 세팅
- 공통 컴포넌트: NadoAlert
```

### 👵🏻 회고 선배
---
 - 지은
	
> 나도선배 iOS 개발을 시작하면서 3명의 코드가 한 사람의 코드처럼 보였으면 좋겠다는 바램을 안고 개발을 시작했었다. 그래서 처음에 와이어프레임을 보며 공통적으로 사용될 부분들을 공통 컴포넌트, 클래스, 베이스 컨트롤러 등으로 만들어서 효율적인 협업을 하자는 제안을 했던 것이 기억난다. 프로젝트 초반엔 공통적인 부분을 3명이서 다 따로 개발해도 문제가 없고 속도도 크게 달라지지 않지만, 프로젝트가 어느정도 진행되며 무거워진 시점에 어느 한 뷰에 변동이 생기거나 갑자기 버튼 스타일이 변경되는 일 등이 생긴다면 모든 스토리보드, 컨트롤러의 값을 일일이 바꿔줘야 하는 불상사가 일어나기 쉽다. 그래서 모든 VC에 공통적으로 자주 사용되는 Button, Navigation Bar, textView, Custom Alert, BottomSheet 등을 공통 UIComponent, Custom Class로 만들어 사용하였다. 
사실 나조차 큰 프로젝트에 재사용 컴포넌트를 도입해 관리하는 경험이 처음이었기에 효용성에 대한 확실한 확신이 없었는데, 프로젝트가 후반부로 달려가면서 앱 규모가 커져가니 재사용 컴포넌트의 효용성은 정말 놀라웠다. 최상위 Class에서 값을 바꿔주면 모든 뷰에서 값이 바뀌는 효율적인 경험을 함께하는 두명의 팀원들에게 직접 체감하며 느끼게 해주었다는 점에서도 스스로도 굉장히 뿌듯했다. 사실 Extension이나 공통 Component를 만들어놓아도 후반부에는 잘 재사용을 안하거나 본인의 코드에 갇히기 마련인데, 우리 팀원들은 범용성을 위해 공통적인 코드를 사용하려고 노력해줘서 그 점도 우리 프로젝트가 효율적으로 관리되는데 한 몫을 했다고 생각한다. 
아무튼간.. 나도선배 짱이고.. 정정빈, 최은주와 같은 팀으로 같은 파트로 개발하게 되어서 너무 많이 성장했고 영광이었고 행복한 3주였다. 우리, 앞으로도 화이팅!
	
 - 은주

> 서버통신에 대한 이해도가 부족한 상태로 앱잼에 참여하게 되어서 마지막 주차에 API를 연결하는 과정이 이번 프로젝트에서 가장 어려웠던 부분이었던 것 같다. 3주차 중반부터 서버를 연결하기 시작했는데, 서버 통신 전반에 대한 이해가 부족하다보니 서버 통신 과정에서 오류가 많이 발생해 팀 전체의 작업이 느려지게 된 것 같아 팀원들에게 가장 미안했다. 
 그럴 때마다 팀원들이 오류를 같이 확인해주고 통신에 실패하는 원인에 대해 상세하게 설명해주며 문제를 해결할 수 있도록 도와주어 잘 해결할 수 있었다. 팀원들이 문제 해결을 대신해주었던 것이 아니라 함께 해결할 수 있도록 도와주며 문제 원인에 대해 상세하게 설명해준 덕분에 점점 서버통신과 앱의 생명주기에 대한 이해도를 높여갈 수 있었으며, 점점 오류도 줄어들게 되어 서버 연결 작업에 속도도 붙을 수 있었다. 개발하면서 힘든 점, 어려운 점이 있다면 항상 본인의 일처럼 도와주고, ‘함께’의 가치를 알고 실천하는 팀원들과 함께할 수 있어서 감사한 시간이었고 팀원들에게서 개발 지식 뿐만 아니라 협업에 필요한 마인드까지 배울 수 있었던 시간이었다. 항상 든든한 팀원인 지은, 정빈에게 고마운 마음을 전하고 싶다.

 - 정빈

> 이전엔 혼자, 혹은 두 명이서 협업한 경험만 있었는데, iOS 개발자 3명 이상과 제대로 된 협업은 처음 해 봤다. 혼자 공부할 때에는 어쩔 수 없이 시야가 좁아지는 느낌이 있다. 어떤 기능을 구현할 줄은 알지만, 구현하는 방법은 한 가지밖에 모른다는 것이다. 혼자 개발할 땐 아무런 문제가 되지 않았지만, 팀원들과 코드 리뷰를 진행하면서는 문제가 되었다. 기획대로 우선 생각나는 대로 개발하고, 나중에 생각하자! 하던 습관과 앱잼 협업 방식이 충돌하여 초반에 좀 속도도 안 나고, 어려웠다는 느낌이 있었다. 이를 극복하기 위해 단순 "코드를 짠다"가 아니라, "효율적인 코드를 짠다"에 초점을 맞추고 스스로도 다양한 방법, 더 효율적인 방법에 대해 한 번 더 생각해 보았다. 또한 내가 익숙한 방식을 경계하도록 노력했다. 팀원들의 피드백도 내 시야를 넓히는 데 많은 도움이 되었고, 나 또한 팀원들의 코드를 가능한 한 모두 보았다. 확실히 보수적이던 내 개발 방식이 앱잼을 하며 개방적인 태도로 바뀐 것 같은 느낌이 들었다.
