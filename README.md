# 🙋🏻‍♀️나도선배 iOS
![Frame 14](https://user-images.githubusercontent.com/63224278/149148867-674514b9-1eec-4b91-9e5d-9fc6b8d3dfa1.png)

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
