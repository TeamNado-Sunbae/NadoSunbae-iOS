//
//  BaseWritePostVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/30.
//

import UIKit
import RxCocoa
import RxSwift

class BaseWritePostVC: BaseVC {

    // MARK: Properties
    private let questionSV = UIScrollView()
    private let disposeBag = DisposeBag()
    private var questionTextViewLineCount: Int = 1
    private var majorID: Int = MajorInfo.shared.selectedMajorID ?? UserDefaults.standard.value(forKey: UserDefaults.Keys.FirstMajorID) as! Int
    
    let questionWriteNaviBar = NadoSunbaeNaviBar().then {
        $0.addShadow(location: .nadoBotttom, color: .shadowDefault, opacity: 0.3, radius: 16)
    }
    
    let questionTitleTextField = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.placeholder = "질문 제목을 입력하세요."
        $0.textColor = .mainDefault
        $0.font = .PretendardSB(size: 24.0)
        $0.autocorrectionType = .no
    }
    
    let textHighlightView = UIView().then {
        $0.backgroundColor = .gray0
    }
    
    let contentHeaderLabel = UILabel().then {
        $0.text = "내용"
        $0.textColor = .black
        $0.font = .PretendardM(size: 16.0)
    }
    
    let questionWriteTextView = NadoTextView()
    let contentView = UIView()
    var confirmAlertMsg: String = ""
    var dismissAlertMsg: String = ""
    var isTextViewEmpty: Bool = true
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitStyle()
        configureUI()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
        hideTabbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
}

// MARK: - UI
extension BaseWritePostVC {
    
    /// UI 구성하는 메서드
    private func configureUI() {
        view.addSubviews([questionWriteNaviBar, questionSV])
        questionSV.addSubview(contentView)
        contentView.addSubviews([questionTitleTextField, textHighlightView, contentHeaderLabel, questionWriteTextView])
        
        questionWriteNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
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
            $0.top.equalToSuperview().offset(24)
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
extension BaseWritePostVC {
    
    /// 컴포넌트의 초기 스타일을 구성하는 메서드
    private func setUpInitStyle() {
        questionWriteNaviBar.setUpNaviStyle(state: .dismissWithNadoBtn)
    }
    
    /// textField가 채워져 있는지에 따라 highlightView 상태 변경하는 메서드
    private func setHighlightViewState(textField: UITextField, highlightView: UIView) {
        textField.rx.text
            .orEmpty
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
    
    /// textView의 상태에 따라 스크롤뷰를 Up, Down 하는 메서드
    func scollByTextViewState(textView: UITextView) {
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
}

// MARK: - Keyboard
extension BaseWritePostVC {
    
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
