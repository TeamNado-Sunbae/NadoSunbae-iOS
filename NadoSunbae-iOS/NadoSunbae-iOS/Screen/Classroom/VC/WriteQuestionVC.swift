//
//  WriteQuestionVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/14.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class WriteQuestionVC: BaseVC {
    
    // MARK: Properties
    private let questionSV = UIScrollView()
    private let contentView = UIView()
    private let disposeBag = DisposeBag()
    private var questionTextViewLineCount: Int = 1
    private var isTextViewEmpty: Bool = true
    private let questionWriteNaviBar = NadoSunbaeNaviBar() 
    private let questionTitleTextField = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.placeholder = "질문 제목을 입력하세요."
        $0.textColor = .mainDefault
        $0.font = .PretendardSB(size: 24.0)
    }
    
    private let textHighlightView = UIView().then {
        $0.backgroundColor = .gray0
    }
    
    private let contentHeaderLabel = UILabel().then {
        $0.text = "내용"
        $0.textColor = .black
        $0.font = .PretendardM(size: 16.0)
    }
    
    private let questionWriteTextView = NadoTextView()
    
    var questionType: QuestionType = .group
    private var majorID: Int = MajorInfo.shared.selecteMajorID ?? UserDefaults.standard.value(forKey: UserDefaults.Keys.FirstMajorID) as! Int
    
    /// 1:1 질문 호출할 때에는 answerID 필수!!!!! 나머지는 설정 X
    var answerID: Int?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setUpInitStyle()
        configureUI()
        setTextViewDelegate()
        setTapBtnAction()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
}

// MARK: - UI
extension WriteQuestionVC {
    
    /// UI 구성하는 메서드
    private func configureUI() {
        view.addSubviews([questionWriteNaviBar, questionSV])
        questionSV.addSubview(contentView)
        contentView.addSubviews([questionTitleTextField, textHighlightView, contentHeaderLabel, questionWriteTextView])
        
        questionWriteNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        questionSV.snp.makeConstraints {
            $0.top.equalTo(questionWriteNaviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        questionTitleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        textHighlightView.snp.makeConstraints {
            $0.top.equalTo(questionTitleTextField.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(questionTitleTextField)
            $0.height.equalTo(1)
        }
        
        contentHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(textHighlightView.snp.bottom).offset(72)
            $0.leading.equalTo(textHighlightView)
        }
        
        questionWriteTextView.snp.makeConstraints {
            $0.top.equalTo(contentHeaderLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(questionTitleTextField)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-102)
        }
        
        setHighlightViewState(textField: questionTitleTextField, highlightView: textHighlightView)
        setActivateBtnState(textField: questionTitleTextField, textView: questionWriteTextView)
    }
}

// MARK: - Custom Method
extension WriteQuestionVC {
    
    /// textView delegate 설정하는 메서드
    private func setTextViewDelegate() {
        questionWriteTextView.delegate = self
    }
    
    /// textField가 채워져 있는지에 따라 highlightView 상태 변경하는 메서드
    private func setHighlightViewState(textField: UITextField, highlightView: UIView) {
        textField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] changedText in
                if self?.questionTitleTextField.text?.isEmpty == true {
                    self?.textHighlightView.backgroundColor = .gray0
                } else {
                    self?.textHighlightView.backgroundColor = .black
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 제목, 내용이 모두 채워져 있는지에 따라 상단 네비바 버튼 활성화/비활성화 하는 메서드
    private func setActivateBtnState(textField: UITextField, textView: NadoTextView) {
        let a = BehaviorSubject<Bool>(value: false)
        let b = BehaviorSubject<Bool>(value: false)
        
        textField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                if changedText.isEmpty {
                    a.onNext(false)
                } else {
                    a.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] changedText in
                if changedText.isEmpty || self?.isTextViewEmpty == true {
                    b.onNext(false)
                } else {
                    b.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(a, b) {$0 && $1}
        .bind(to: questionWriteNaviBar.rightActivateBtn.rx.isActivated)
        .disposed(by: disposeBag)
    }
    
    /// btn Action set 메서드
    private func setTapBtnAction() {
        /// rightActivat Btn Press
        questionWriteNaviBar.rightActivateBtn.press {
            guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            alert.showNadoAlert(vc: self, message:
    """
    글을 올리시겠습니까?
    """
                                , confirmBtnTitle: "네", cancelBtnTitle: "아니요")
            alert.confirmBtn.press {
                switch self.questionType {
                case .group, .info:
                    self.answerID = nil
                default:
                    break
                }
                self.createClassroomPost(majorID: self.majorID, answerID: self.answerID ?? nil, postTypeID: self.questionType.rawValue, title: self.questionTitleTextField.text ?? "", content: self.questionWriteTextView.text ?? "")
            }
        }
        
        /// dismissBtn Press
        questionWriteNaviBar.dismissBtn.press {
            guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            alert.showNadoAlert(vc: self, message:
    """
    페이지를 나가면
    작성중인 글이 삭제돼요.
    """
                                , confirmBtnTitle: "계속 작성", cancelBtnTitle: "나갈래요")
            alert.cancelBtn.press {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /// textView의 상태에 따라 스크롤뷰를 Up, Down 하는 메서드
    private func scollByTextViewState(textView: UITextView) {
        var contentOffsetY = questionSV.contentOffset.y
        var isLineAdded = true
        
        if questionTextViewLineCount != textView.numberOfLines() {
            
            if questionTextViewLineCount > textView.numberOfLines() {
                isLineAdded = false
            } else {
                isLineAdded = true
            }
            
            if  isLineAdded && textView.numberOfLines() > 8 && questionSV.contentOffset.y < 243 {
                contentOffsetY += 38
                questionSV.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: true)
                
            } else if !isLineAdded && questionTextViewLineCount < 14 && questionSV.contentOffset.y > 0 {
                
                if contentOffsetY - 38 > 0 {
                    contentOffsetY -= 38
                    questionSV.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: true)
                } else {
                    contentOffsetY = 0
                    questionSV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
        }
        questionTextViewLineCount = textView.numberOfLines()
    }
    
    private func setUpInitStyle() {
        questionWriteNaviBar.setUpNaviStyle(state: .dismissWithNadoBtn)
        
        switch questionType {
        case .personal:
            questionWriteNaviBar.configureTitleLabel(title: "1:1 질문 작성")
            questionWriteTextView.setDefaultStyle(placeholderText: "선배에게 1:1 질문을 남겨보세요.\n선배가 답변해 줄 거에요!")
        case .group:
            questionWriteNaviBar.configureTitleLabel(title: "전체에게 질문")
            questionWriteTextView.setDefaultStyle(placeholderText: "질문을 남겨보세요.\n선배들이 답변해 줄 거에요!")
        case .info:
            questionWriteNaviBar.configureTitleLabel(title: "정보글 작성")
            questionWriteTextView.setDefaultStyle(placeholderText: "구성원에게 유용한 학과 정보를 공유해주세요.")
        }
    }
}

// MARK: - UITextViewDelegate
extension WriteQuestionVC: UITextViewDelegate {
    
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
    }
    
    /// textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        isTextViewEmpty = false
        scollByTextViewState(textView: textView)
    }
    
    /// textViewDidEndEditing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            switch questionType {
            case .personal:
                textView.text = "선배에게 1:1 질문을 남겨보세요.\n선배가 답변해 줄 거에요!"
            case .group:
                textView.text = "질문을 남겨보세요.\n선배들이 답변해 줄 거에요!"
            case .info:
                textView.text = "구성원에게 유용한 학과 정보를 공유해주세요."
            }
            textView.textColor = .gray2
            isTextViewEmpty = true
        }
    }
}

// MARK: - Keyboard
extension WriteQuestionVC {
    
    /// Keyboard Observer add 메서드
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Keyboard Observer remove 메서드
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// keyboardWillHide
    @objc
    func keyboardWillHide(notification: Notification) {
        questionSV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

// MARK: - Network
extension WriteQuestionVC {
    private func createClassroomPost(majorID: Int, answerID: Int?, postTypeID: Int, title: String, content: String) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.createClassroomContentAPI(majorID: majorID, answerID: answerID ?? nil, postTypeID: postTypeID, title: title, content: content) { networkResult in
            switch networkResult {
            case .success(let res):
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                print("pathErr")
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
