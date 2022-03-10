//
//  ReviewWriteVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/13.
//

import UIKit

class ReviewWriteVC: BaseVC {
    
    // MARK: IBOutlet
    @IBOutlet weak var reviewWriteNaviBar: NadoSunbaeNaviBar! {
        didSet {
            
            /// x버튼 클릭 시 커스텀 팝업창 띄움
            reviewWriteNaviBar.dismissBtn.press {
                guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
                if self.isPosting {
                    alert.showNadoAlert(vc: self, message: "페이지를 나가면 \n 작성중인 글이 삭제돼요.", confirmBtnTitle: "계속 작성", cancelBtnTitle: "나갈래요")
                } else {
                    alert.showNadoAlert(vc: self, message: "페이지를 나가면 \n 수정한 내용이 저장되지 않아요.", confirmBtnTitle: "계속 작성", cancelBtnTitle: "나갈래요")
                }
                alert.cancelBtn.press {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBOutlet weak var reviewWriteScrollView: UIScrollView!
    @IBOutlet weak var essentialTagView: UIView!
    @IBOutlet weak var choiceTagView: UIView!
    @IBOutlet weak var majorNameView: UIView!
    @IBOutlet weak var bgImgCV: UICollectionView!
    @IBOutlet weak var majorNameLabel: UILabel! {
        didSet {
            majorNameLabel.text = UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)
        }
    }
    @IBOutlet weak var majorChangeBtn: UIButton!
    @IBOutlet weak var oneLineReviewTextView: NadoTextView!
    @IBOutlet weak var prosAndConsTextView: NadoTextView!
    @IBOutlet weak var learnInfoTextView: NadoTextView!
    @IBOutlet weak var recommendClassTextView: NadoTextView!
    @IBOutlet weak var badClassTextView: NadoTextView!
    @IBOutlet weak var futureTextView: NadoTextView!
    @IBOutlet weak var tipTextView: NadoTextView! {
        didSet {
            oneLineReviewTextView.setDefaultStyle(isUsePlaceholder: true, placeholderText: "학과를 한줄로 표현한다면?")
            [prosAndConsTextView, learnInfoTextView, recommendClassTextView, badClassTextView, futureTextView, tipTextView].forEach { textView in
                textView?.setDefaultStyle(isUsePlaceholder: true, placeholderText: "내용을 입력해주세요")
            }
        }
    }
    
    @IBOutlet weak var oneLineReviewCountLabel: UILabel!
    @IBOutlet weak var prosAndConsCountLabel: UILabel!
    @IBOutlet weak var learnInfoCountLabel: UILabel!
    @IBOutlet weak var recommendClassCountLabel: UILabel!
    @IBOutlet weak var badClassCountLabel: UILabel!
    @IBOutlet weak var futureCountLabel: UILabel!
    @IBOutlet weak var tipCountLabel: UILabel!
    
    // MARK: Properties
    
    /// 완료 버튼 활성화 검사를 위한 변수
    private var essentialTextViewStatus: Bool = false
    private var choiceTextViewStatus: Bool = false
    var bgImgID: Int = 6
    
    /// 데이터 삽입을 위한 리스트 변수
    private var bgImgList: [ReviewWriteBgImgData] = []
    
    // 새글 작성, 기존글 수정 구분 위한 변수
    var isPosting: Bool = true
    var postID: Int = 0
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCVC()
        setUpCV()
        setTextViewDelegate()
        initBgImgList()
        configureNaviUI()
        configureTagViewUI()
        configureMajorNameViewUI()
        addKeyboardObserver()
        hideKeyboardWhenTappedAround()
        setUpTapCompleteBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureChangeBtnUI()
        [oneLineReviewTextView, prosAndConsTextView, learnInfoTextView, recommendClassTextView, badClassTextView, futureTextView, tipTextView].forEach {
            textView in setUpCompleteBtnStatus(textView: textView)
        }
        [oneLineReviewTextView, prosAndConsTextView, learnInfoTextView, recommendClassTextView, badClassTextView, futureTextView, tipTextView].forEach {
            textView in setUpCharCount(textView: textView)
        }
        setUpDefaultBgImg()
    }
    
    @IBAction func tapMajorChangeBtn(_ sender: Any) {
        let firstMajor: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? ""
        let secondMajor: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) ?? ""
        
        let alert = UIAlertController(title: "후기 작성 학과", message: nil, preferredStyle: .actionSheet)
        let majorName = UIAlertAction(title: firstMajor, style: .default) { action in
            self.majorNameLabel.text = firstMajor
        }
        let secondMajorName = UIAlertAction(title: secondMajor, style: .default) { action in
            self.majorNameLabel.text = secondMajor
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(majorName)
        alert.addAction(secondMajorName)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UI
extension ReviewWriteVC {
    private func configureChangeBtnUI() {
        
        /// 회원가입 시 본전공만 존재하는 유저인 경우 혹은 후기글 수정 시 버튼 비활성화 처리
        if UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) == "미진입" || !isPosting {
            majorChangeBtn.isEnabled = false
            majorChangeBtn.tintColor = UIColor.gray3
        }
    }
    
    private func configureNaviUI() {
        reviewWriteNaviBar.setUpNaviStyle(state: .dismissWithNadoBtn)
        reviewWriteNaviBar.configureTitleLabel(title: "후기작성")
    }

    private func configureTagViewUI() {
        essentialTagView.makeRounded(cornerRadius: 4.adjusted)
        choiceTagView.makeRounded(cornerRadius: 4.adjusted)
    }

    private func configureMajorNameViewUI() {
        majorNameView.makeRounded(cornerRadius: 4.adjusted)
        majorNameView.layer.borderColor = UIColor.gray0.cgColor
        majorNameView.layer.borderWidth = 1
    }
}

// MARK: - Custom Methods
extension ReviewWriteVC {
    private func registerCVC() {
        ReviewWriteBgImgCVC.register(target: bgImgCV)
    }
    
    private func setUpCV() {
        bgImgCV.dataSource = self
        bgImgCV.delegate = self
    }
    
    /// TextView delegate 설정
    private func setTextViewDelegate() {
        [oneLineReviewTextView, prosAndConsTextView, learnInfoTextView, recommendClassTextView, badClassTextView, futureTextView, tipTextView].forEach { textView in
            textView?.delegate = self
        }
    }
    
    private func initBgImgList() {
        bgImgList.append(contentsOf: [
            ReviewWriteBgImgData(bgImgName: "property1Mint"),
            ReviewWriteBgImgData(bgImgName: "propertyBlack"),
            ReviewWriteBgImgData(bgImgName: "property1Skyblue"),
            ReviewWriteBgImgData(bgImgName: "property1Pink"),
            ReviewWriteBgImgData(bgImgName: "property1Navy"),
            ReviewWriteBgImgData(bgImgName: "property1Orange"),
            ReviewWriteBgImgData(bgImgName: "property1Purple")
        ])
    }
    
    /// 디폴트로 선택된 배경 이미지 설정 함수
    private func setUpDefaultBgImg() {
        self.bgImgCV.selectItem(at: IndexPath(item: bgImgID - 6, section: 0), animated: true, scrollPosition: .left)
    }
    
    /// 조건에 따라 완료버튼 상태 설정하는 함수
    private func setUpCompleteBtnStatus(textView: UITextView) {
        
        /// 필수 항목 모두 작성되었을 때
        if oneLineReviewTextView.text != "학과를 한줄로 표현한다면?" && oneLineReviewTextView.text.count > 0 && prosAndConsTextView.text.count >= 100  {
            essentialTextViewStatus = true
        } else {
            essentialTextViewStatus = false
        }
        
        
        /// 선택 항목 분기 처리
        [learnInfoTextView, recommendClassTextView, badClassTextView, futureTextView, tipTextView].forEach {
            if textView == $0 {
                for _ in 0...4 {
                    if ($0?.text.count)! >= 100 {
                        choiceTextViewStatus = true
                    } else if $0?.text.isEmpty == true {
                        //  선택 textView가 최소1개 이상채워졌는지 분기처리
                        if learnInfoTextView.text.count >= 100 || recommendClassTextView.text.count >= 100 || badClassTextView.text.count >= 100 || futureTextView.text.count >= 100 || tipTextView.text.count >= 100 {
                            choiceTextViewStatus = true
                        } else {
                            choiceTextViewStatus = false
                        }
                    } else if $0?.textColor != .gray2 {
                        choiceTextViewStatus = false
                    }
                }
            }
        }
        
        /// 완료 버튼 활성화 조건 (필수작성항목 모두 채워지고, 선택항목 조건 달성)
        reviewWriteNaviBar.rightActivateBtn.isActivated = essentialTextViewStatus && choiceTextViewStatus
    }
    
    /// Label에 TextView 글자수 표시하는 함수
    private func setUpCharCount(textView: UITextView) {
        if textView == oneLineReviewTextView {
            if textView.text != "학과를 한줄로 표현한다면?" {
                oneLineReviewCountLabel.text = "\(oneLineReviewTextView.text.count)/최대 40자"
            }
        }
        if textView.text != "내용을 입력해주세요" {
            if textView == prosAndConsTextView {
                prosAndConsCountLabel.text = "\(prosAndConsTextView.text.count)/최소 100자"
            } else if textView == learnInfoTextView {
                learnInfoCountLabel.text = "\(learnInfoTextView.text.count)/최소 100자"
            } else if textView == recommendClassTextView {
                recommendClassCountLabel.text = "\(recommendClassTextView.text.count)/최소 100자"
            } else if textView == badClassTextView {
                badClassCountLabel.text = "\(badClassTextView.text.count)/최소 100자"
            } else if textView == futureTextView {
                futureCountLabel.text = "\(futureTextView.text.count)/최소 100자"
            } else if textView == tipTextView {
                tipCountLabel.text = "\(tipTextView.text.count)/최소 100자"
            }
        }
    }
    
    /// ReviewDetailVC에서 상태값 받아오기 위한 함수
    func setReceivedData(status: Bool, postId: Int, bgImgId: Int) {
        isPosting = status
        postID = postId
        bgImgID = bgImgId
    }
    
    private func setUpTapCompleteBtn() {
        reviewWriteNaviBar.rightActivateBtn.press(vibrate: true, for: .touchUpInside) {
            guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            alert.showNadoAlert(vc: self, message: "글을 올리시겠습니까?", confirmBtnTitle: "네", cancelBtnTitle: "아니요")
            
            /// 완료 버튼 클릭 시
            alert.confirmBtn.press {
                if self.isPosting {
                    
                    /// 게시글 등록 서버통신
                    if self.majorNameLabel.text == UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) {
                        self.requestCreateReviewPost(majorID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID), bgImgID: self.bgImgID, oneLineReview: self.oneLineReviewTextView.text, prosCons: self.prosAndConsTextView.text, curriculum: self.learnInfoTextView.text, career: self.futureTextView.text, recommendLecture: self.recommendClassTextView.text, nonRecommendLecture: self.badClassTextView.text, tip: self.tipTextView.text)
                    } else if self.majorNameLabel.text == UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) {
                        self.requestCreateReviewPost(majorID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.SecondMajorID), bgImgID: self.bgImgID, oneLineReview: self.oneLineReviewTextView.text, prosCons: self.prosAndConsTextView.text, curriculum: self.learnInfoTextView.text, career: self.futureTextView.text, recommendLecture: self.recommendClassTextView.text, nonRecommendLecture: self.badClassTextView.text, tip: self.tipTextView.text)
                    }
                    UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsReviewed)
                } else {
                    
                    /// 게시글 수정 서버통신
                    self.requestEditReviewPost(postID: self.postID, bgImgID: self.bgImgID, oneLineReview: self.oneLineReviewTextView.text, prosCons: self.prosAndConsTextView.text, curriculum: self.learnInfoTextView.text, career: self.futureTextView.text, recommendLecture: self.recommendClassTextView.text, nonRecommendLecture: self.badClassTextView.text, tip: self.tipTextView.text)
                }
            }
            
            /// TextView의 text가 placeholder일 때 텍스트가 서버에 넘어가지 않도록 분기 처리
            [self.learnInfoTextView, self.recommendClassTextView, self.badClassTextView, self.futureTextView, self.tipTextView].forEach {
                for _ in 0...4 {
                    if $0?.text == "내용을 입력해주세요" {
                        $0?.text = ""
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReviewWriteVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewWriteVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bgImgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewWriteBgImgCVC.className, for: indexPath) as? ReviewWriteBgImgCVC else { return UICollectionViewCell() }
        
        cell.setData(imgData: bgImgList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.bgImgID = indexPath.row + 6
    }
}

// MARK: - UITextViewDelegate
extension ReviewWriteVC: UITextViewDelegate {
    
    /// scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async() {
            scrollView.scrollIndicators.vertical?.backgroundColor = .scrollMint
        }
    }
    
    /// textViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray2 {
            textView.text = nil
            textView.textColor = .mainText
        }
        
        // TODO: 다른 디바이스 화면에도 대응하기 위한 분기처리 예정
        
        if screenHeight == 667 {
            
            /// 키보드가 올라감에 따라 scrollView Offset 처리(아이폰 11, 12 기준)
            if textView == oneLineReviewTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 240), animated: true)
            } else if textView == prosAndConsTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 340), animated: true)
            } else if textView == learnInfoTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 600), animated: true)
            } else if textView == recommendClassTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 800), animated: true)
            } else if textView == badClassTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 1000), animated: true)
            } else if textView == futureTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 1180), animated: true)
            } else if textView == tipTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 1300), animated: true)
            }
        } else {
            if textView == oneLineReviewTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
            } else if textView == prosAndConsTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            } else if textView == learnInfoTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 445), animated: true)
            } else if textView == recommendClassTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 620), animated: true)
            } else if textView == badClassTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 790), animated: true)
            } else if textView == futureTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 960), animated: true)
            } else if textView == tipTextView {
                reviewWriteScrollView.setContentOffset(CGPoint(x: 0, y: 1130), animated: true)
            }
        }
    }
    
    /// textViewDidEndEditing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == oneLineReviewTextView {
                textView.text = "학과를 한줄로 표현한다면?"
            } else {
                textView.text = "내용을 입력해주세요"
            }
            textView.textColor = .gray2
        }
    }
    
    /// 글자 수 제한을 위한 함수
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == oneLineReviewTextView {
            
            /// 최대 글자수 - 1
            let maxCount = 39
            
            /// 이전 글자 - 선택된 글자 + 새로운 글자(대체될 글자)
            let newLength = textView.text.count - range.length + text.count
            let koreanMaxCount = maxCount + 1 // 최대 글자수
            
            /// 글자수가 초과 된 경우 or 초과되지 않은 경우
            if newLength > koreanMaxCount {
                let overflow = newLength - koreanMaxCount //초과된 글자수
                if text.count < overflow {
                    return true
                }
                let index = text.index(text.endIndex, offsetBy: -overflow)
                let newText = text[..<index]
                guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
                guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
                guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
                
                textView.replace(textRange, withText: String(newText))
                
                return false
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        /// 텍스트뷰의 내용이 바뀔때 마다 조건 판단하기 위한 함수 호출
        setUpCompleteBtnStatus(textView: textView)
        
        /// 글자수 표시
        setUpCharCount(textView: textView)
        
        /// 텍스트뷰 내 indicator 백그라운드 컬러 설정
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            DispatchQueue.main.async() {
                scrollView.scrollIndicators.vertical?.backgroundColor = .scrollMint
            }
        }
    }
}

// MARK: - Extension Part
extension ReviewWriteVC {
    
    /// Keyboard Observer add 메서드
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        reviewWriteScrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        reviewWriteScrollView.contentInset.bottom = 0
    }
}

// MARK: - Network
extension ReviewWriteVC {
    
    /// 게시글 등록
    func requestCreateReviewPost(majorID: Int, bgImgID: Int, oneLineReview: String, prosCons: String, curriculum: String, career: String, recommendLecture: String, nonRecommendLecture: String, tip: String) {
        ReviewAPI.shared.createReviewPostAPI(majorID: majorID, bgImgID: bgImgID, oneLineReview: oneLineReview, prosCons: prosCons, curriculum: curriculum, career: career, recommendLecture: recommendLecture, nonRecommendLecture: nonRecommendLecture, tip: tip) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if let data = res as? ReviewPostRegisterData {
                    self.dismiss(animated: true)
                    print(data)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.activityIndicator.stopAnimating()
                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    }
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    /// 게시글 수정
    func requestEditReviewPost(postID: Int, bgImgID: Int, oneLineReview: String, prosCons: String, curriculum: String, career: String, recommendLecture: String, nonRecommendLecture: String, tip: String) {
        ReviewAPI.shared.editReviewPostAPI(postID: postID, bgImgID: bgImgID, oneLineReview: oneLineReview, prosCons: prosCons, curriculum: curriculum, career: career, recommendLecture: recommendLecture, nonRecommendLecture: nonRecommendLecture, tip: tip) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if res is ReviewEditData {
                    self.dismiss(animated: true)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.activityIndicator.stopAnimating()
                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
