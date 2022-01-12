# NadoSunbae-iOS
![2603983B5395389D20](https://user-images.githubusercontent.com/43312096/148688053-e5c9f544-af85-47b4-94e6-8fa051bc608e.jpeg)

> **아는 선배 없어도 괜찮아! 우리 같이 서로의 선배가 되어주자!**  
제2전공생을 위한 학과후기, 전공정보 공유 플랫폼 - 나도선배
>
> 29th WE SOPT APPJAM <br>
> 프로젝트 기간 : 2022.01.02 ~ 2021.01.22
## 🙋🏻‍♀️ NadoSunbae iOS Developers
 <img src="https://user-images.githubusercontent.com/63277563/148170419-f698eab4-87e5-4aa9-81ad-5a43fd7f2231.jpg" width="200"> | <img src="https://user-images.githubusercontent.com/63277563/148170415-143c21bb-7c38-42a4-990e-01f0f2db3d6a.png" width="200"> | <img src="https://user-images.githubusercontent.com/63277563/148170409-053650f4-daf0-42db-aa67-d3c3725904f5.png" width="200"> |
 :---------:|:----------:|:---------:|
 🍎 **지은선배** 🍎 | 🍎 **정빈선배** 🍎  | 🍎 **은주선배** 🍎
 [@hwangJi-dev](https://github.com/hwangJi-dev)  |  [@dev-madilyn](https://github.com/dev-madilyn)  |  [@jane1choi](https://github.com/jane1choi)  | 

## ✨Coding Convention
<details markdown="1">
<summary>네이밍</summary>

### Class & Struct
- 클래스/구조체 이름은 **UpperCamelCase**를 사용합니다.

### 함수, 변수, 상수
- 함수와 변수에는 **lowerCamelCase**를 사용합니다.
- 버튼명에는 **Btn 약자**를 사용합니다.
- 모든 IBOutlet에는 해당 클래스명을 뒤에 붙입니다.  
  
  <kbd>예외</kbd> Image는 항상 Img로 줄여서 네이밍합니다.
  ```swift
  @IBOutlet weak var settingImgView: UIImageView!
    ```
- 기본 클래스 파일을 생성하거나 컴포넌트를 생성할 때는 약어 규칙에 따라 네이밍합니다.  

  - 예시
     
    `VC` `TV` `TVC` `CV` `CVC`
    
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
  
#### 📍함수 네이밍
- `setUp` → setUpDelegate (기능관련 함수)
- `configure` → configureUI (UI관련 함수)   
- `IBAction`
    - **tap**DismissBtn() → 단순 클릭
    - **present**ResultVC() → 화면전환 메소드(push, present, pop, dismiss)

</details>

<details markdown="2">
<summary>📍주석</summary>
 
**MARK 주석**

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
 
</details>

<details markdown="3">
<summary>📍공백</summary>
 
- 탭 사이즈는 2로 사용합니다.
- 한 줄의 최대 길이는 80자로 제한합니다.
- 최대 tab depth 제한
  - tab의 최대 depth는 4로 제한합니다.
  - 이 이상으로 depth가 길어지면 함수를 통해 나눌 수 있도록 합니다.
  - 그 이상으로 개선할 수 없다고 판단되는 경우, 팀원들과의 코드리뷰를 통해 개선합니다.  
   
- 괄호 사용
  - (if, while, for)문 괄호 뒤에 한칸을 띄우고 사용합니다.
 
  ```typescript
     if (left == true) {
	   // logic
     }
     ```
  
- 띄어쓰기
 
  ```Swift
  let a = 5;  ( = 양쪽 사이로 띄어쓰기 하기)
  if (a == 3) {
	  // logic
  }
  ```
</details>

<details markdown="4">
<summary>📍기타규칙</summary>  
 
 - 외부에서 사용되지 않을 변수나 함수는 `private`으로 선언합니다.
 
</details>

## ✨Commit Convention

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

## ✨Github Management

## ✨Fordering Convention
