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
    
    @IBOutlet weak var oneLineReviewTextView: NadoTextView! {
        didSet {
            oneLineReviewTextView.setDefaultStyle(placeholderText: "학과를 한줄로 표현한다면?")
        }
    }
    
    @IBOutlet weak var prosAndConsTextView: NadoTextView! {
        didSet {
            prosAndConsTextView.setDefaultStyle(placeholderText: "내용을 입력해주세요")
        }
    }
    
    @IBOutlet weak var learnInfoTextView: NadoTextView! {
        didSet {
            learnInfoTextView.setDefaultStyle(placeholderText: "내용을 입력해주세요")
        }
    }
    
    @IBOutlet weak var recommendClassTextView: NadoTextView! {
        didSet {
            recommendClassTextView.setDefaultStyle(placeholderText: "내용을 입력해주세요")
        }
    }
    
    @IBOutlet weak var badClassTextView: NadoTextView! {
        didSet {
            badClassTextView.setDefaultStyle(placeholderText: "내용을 입력해주세요")
        }
    }
    
    @IBOutlet weak var futureTextView: NadoTextView! {
        didSet {
            futureTextView.setDefaultStyle(placeholderText: "내용을 입력해주세요")
        }
    }
    
    @IBOutlet weak var tipTextView: NadoTextView! {
        didSet {
            tipTextView.setDefaultStyle(placeholderText: "내용을 입력해주세요")
        }
    }

    var bgImgList: [ReviewWriteBgImgData] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCVC()
        setUpCV()
        initBgImgList()
        customNaviUI()
        configureTagViewUI()
        configureMajorNameViewUI()
        setTextViewDelegate()
        addKeyboardObserver()
        hideKeyboardWhenTappedAround()
    }
    
    private func registerCVC() {
        ReviewWriteBgImgCVC.register(target: bgImgCV)
    }
    
    private func setUpCV() {
        bgImgCV.dataSource = self
        bgImgCV.delegate = self
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
    
    /// TextView delegate 설정
    private func setTextViewDelegate() {
        oneLineReviewTextView.delegate = self
        prosAndConsTextView.delegate = self
        learnInfoTextView.delegate = self
        recommendClassTextView.delegate = self
        badClassTextView.delegate = self
        futureTextView.delegate = self
        tipTextView.delegate = self
    }
    
    @IBAction func tapMajorChangeBtn(_ sender: Any) {
        let alert = UIAlertController(title: "후기 작성 학과", message: nil, preferredStyle: .actionSheet)

        let majorName = UIAlertAction(title: "본전공명", style: .default) { action in
            self.majorNameLabel.text = "국어국문학과"
        }
        
        // TODO: 회원가입 시 본전공만 존재하는 유저인 경우 분기 처리 예정
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
    func customNaviUI() {
        reviewWriteNaviBar.setUpNaviStyle(state: .dismissWithNadoBtn)
        reviewWriteNaviBar.configureTitleLabel(title: "후기작성")
    }
    
    func configureTagViewUI() {
        essentialTagView.layer.cornerRadius = 4
        choiceTagView.layer.cornerRadius = 4
    }
    
    func configureMajorNameViewUI() {
        majorNameView.layer.cornerRadius = 8
        majorNameView.layer.borderColor = UIColor.gray0.cgColor
        majorNameView.layer.borderWidth = 1
    }
}

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
        
        /// 키보드 처리
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async() {
            scrollView.scrollIndicators.vertical?.backgroundColor = .scrollMint
        }
    }
}

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

