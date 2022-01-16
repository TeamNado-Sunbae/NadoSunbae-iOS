//
//  ReviewWriteVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/13.
//

import UIKit

class ReviewWriteVC: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var reviewWriteNaviBar: NadoSunbaeNaviBar! {
        didSet {
            reviewWriteNaviBar.dismissBtn.press {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var reviewWriteScrollView: UIScrollView!
    @IBOutlet weak var essentialTagView: UIView!
    @IBOutlet weak var choiceTagView: UIView!
    @IBOutlet weak var majorNameView: UIView!
    @IBOutlet weak var bgImgCV: UICollectionView!
    @IBOutlet weak var majorNameLabel: UILabel!
    @IBOutlet weak var oneLineReviewTextView: NadoTextView!
    @IBOutlet weak var prosAndConsTextView: NadoTextView!
    @IBOutlet weak var learnInfoTextView: NadoTextView!
    @IBOutlet weak var recommendClassTextView: NadoTextView!
    @IBOutlet weak var badClassTextView: NadoTextView!
    @IBOutlet weak var futureTextView: NadoTextView!
    @IBOutlet weak var tipTextView: NadoTextView! {
        didSet {
            oneLineReviewTextView.setDefaultStyle(placeholderText: "학과를 한줄로 표현한다면?")
            [prosAndConsTextView, learnInfoTextView, recommendClassTextView, badClassTextView, futureTextView, tipTextView].forEach { textView in
                textView?.setDefaultStyle(placeholderText: "내용을 입력해주세요")
            }
        }
    }
    
    // MARK: Properties
    
    /// 완료 버튼 활성화 검사를 위한 변수
    private var essentialTextViewStatus: Bool = false
    private var choiceTextViewStatus: Bool = false
    
    /// 데이터 삽입을 위한 리스트 변수
    private var bgImgList: [ReviewWriteBgImgData] = []
    
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
    }
    
    // MARK: Custom Method
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
            ReviewWriteBgImgData(bgImgName: "bgSample"),
            ReviewWriteBgImgData(bgImgName: "bgSample"),
            ReviewWriteBgImgData(bgImgName: "bgSample"),
            ReviewWriteBgImgData(bgImgName: "bgSample"),
            ReviewWriteBgImgData(bgImgName: "bgSample"),
            ReviewWriteBgImgData(bgImgName: "bgSample"),
            ReviewWriteBgImgData(bgImgName: "bgSample"),
            ReviewWriteBgImgData(bgImgName: "bgSample"),
            ReviewWriteBgImgData(bgImgName: "bgSample"),
        ])
    }
    
    // TODO: 회원가입 시 본전공만 존재하는 유저인 경우 버튼 비활성화 처리 예정
    @IBAction func tapMajorChangeBtn(_ sender: Any) {
        let alert = UIAlertController(title: "후기 작성 학과", message: nil, preferredStyle: .actionSheet)
        let majorName = UIAlertAction(title: "본전공명", style: .default) { action in
            self.majorNameLabel.text = "국어국문학과"
        }
        let secondMajorName = UIAlertAction(title: "제2전공명", style: .default) { action in
            self.majorNameLabel.text = "디지털미디어학과"
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
    func configureNaviUI() {
        reviewWriteNaviBar.setUpNaviStyle(state: .dismissWithNadoBtn)
        reviewWriteNaviBar.configureTitleLabel(title: "후기작성")
    }
    
    func configureTagViewUI() {
        essentialTagView.makeRounded(cornerRadius: 4.adjusted)
        choiceTagView.makeRounded(cornerRadius: 4.adjusted)
    }
    
    func configureMajorNameViewUI() {
        majorNameView.makeRounded(cornerRadius: 4.adjusted)
        majorNameView.layer.borderColor = UIColor.gray0.cgColor
        majorNameView.layer.borderWidth = 1
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
}

// MARK: - UITextViewDelegate
extension ReviewWriteVC: UITextViewDelegate {
    
    /// textViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray2 {
            textView.text = nil
            textView.textColor = .mainText
        }
        
        // TODO: 다른 디바이스 화면에도 대응하기 위한 분기처리 예정
        
        /// 키보드가 올라감에 따라 scrollView Offset 처리(아이폰 11, 12 기준)
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
        
        /// 필수 항목 모두 작성되었을 때
        if oneLineReviewTextView.text.count > 0 && prosAndConsTextView.text.count >= 100  {
            essentialTextViewStatus = true
        }
        
        /// 선택항목 중 하나가 100자 이상 채워졌을 때 다른 텍스트뷰에 글자가 입력되지 않았을때 or 100자 이상일 때 활성화
        if learnInfoTextView.text.count >= 100 {
            if (recommendClassTextView.text == "내용을 입력해주세요" || recommendClassTextView.text.count >= 100) && (badClassTextView.text == "내용을 입력해주세요" || badClassTextView.text.count >= 100) && (futureTextView.text == "내용을 입력해주세요" || futureTextView.text.count >= 100) && (tipTextView.text == "내용을 입력해주세요" || tipTextView.text.count >= 100) && essentialTextViewStatus == true {
                reviewWriteNaviBar.rightActivateBtn.isActivated = true
                reviewWriteNaviBar.rightActivateBtn.press {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                reviewWriteNaviBar.rightActivateBtn.isActivated = false
            }
        }
        
        if recommendClassTextView.text.count >= 100 {
            if (learnInfoTextView.text == "내용을 입력해주세요" || learnInfoTextView.text.count >= 100) && (badClassTextView.text == "내용을 입력해주세요" || badClassTextView.text.count >= 100) && (futureTextView.text == "내용을 입력해주세요" || futureTextView.text.count >= 100) && (tipTextView.text == "내용을 입력해주세요" || tipTextView.text.count >= 100) && essentialTextViewStatus == true {
                reviewWriteNaviBar.rightActivateBtn.isActivated = true
                reviewWriteNaviBar.rightActivateBtn.press {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                reviewWriteNaviBar.rightActivateBtn.isActivated = false
            }
        }
        
       if badClassTextView.text.count >= 100 {
            if (learnInfoTextView.text == "내용을 입력해주세요" || learnInfoTextView.text.count >= 100) && (recommendClassTextView.text == "내용을 입력해주세요" || recommendClassTextView.text.count >= 100) && (futureTextView.text == "내용을 입력해주세요" || futureTextView.text.count >= 100) && (tipTextView.text == "내용을 입력해주세요" || tipTextView.text.count >= 100) && essentialTextViewStatus == true {
                reviewWriteNaviBar.rightActivateBtn.isActivated = true
                reviewWriteNaviBar.rightActivateBtn.press {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                reviewWriteNaviBar.rightActivateBtn.isActivated = false
            }
        }
        
        if futureTextView.text.count >= 100 {
            if (learnInfoTextView.text == "내용을 입력해주세요" || learnInfoTextView.text.count >= 100) && (recommendClassTextView.text == "내용을 입력해주세요" || recommendClassTextView.text.count >= 100) && (badClassTextView.text == "내용을 입력해주세요" || badClassTextView.text.count >= 100) && (tipTextView.text == "내용을 입력해주세요" || tipTextView.text.count >= 100) && essentialTextViewStatus == true {
                reviewWriteNaviBar.rightActivateBtn.isActivated = true
                reviewWriteNaviBar.rightActivateBtn.press {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                reviewWriteNaviBar.rightActivateBtn.isActivated = false
            }
        }
        
        if tipTextView.text.count >= 100 {
            if (learnInfoTextView.text == "내용을 입력해주세요" || learnInfoTextView.text.count >= 100) && (recommendClassTextView.text == "내용을 입력해주세요" || recommendClassTextView.text.count >= 100) && (badClassTextView.text == "내용을 입력해주세요" || badClassTextView.text.count >= 100) && (futureTextView.text == "내용을 입력해주세요" || futureTextView.text.count >= 100) && essentialTextViewStatus == true {
                reviewWriteNaviBar.rightActivateBtn.isActivated = true
                reviewWriteNaviBar.rightActivateBtn.press {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                reviewWriteNaviBar.rightActivateBtn.isActivated = false
            }
        }
        
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

