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
import FirebaseAnalytics

class WriteQuestionVC: BaseWritePostVC {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    var isEditState: Bool = false
    var answererID: Int?
    var postID: Int?
    var originTitle: String?
    var originContent: String?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitStyle()
        setTapBtnAction()
        setTextViewDelegate()
        setUpAlertMsgByEditState()
    }
}

// MARK: - Custom Method
extension WriteQuestionVC {
    
    /// 컴포넌트의 초기 스타일을 구성하는 메서드
    private func setUpInitStyle() {
        if isEditState {
            self.makeScreenAnalyticsEvent(screenName: "Classroom Tab", screenClass: "ReviewWriteVC+Edit")
            isTextViewEmpty = false
            questionWriteTextView.setDefaultStyle(isUsePlaceholder: false, placeholderText: "")
            questionTitleTextField.text = originTitle
            questionWriteTextView.text = originContent
            questionWriteNaviBar.rightActivateBtn.isActivated = true
        } else {
            questionWriteTextView.setDefaultStyle(isUsePlaceholder: true, placeholderText: "선배에게 1:1 질문을 남겨보세요.\n선배가 답변해 줄 거에요!")
        }
        
        questionWriteNaviBar.configureTitleLabel(title: "1:1 질문 작성")
    }
    
    /// textView delegate 설정하는 메서드
    private func setTextViewDelegate() {
        questionWriteTextView.delegate = self
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
        
        /// 수정상태일 때 (title, content가 있는 상황이므로) 첫 진입상태를 isActivate로 하기 위한 분기처리
        if isEditState {
            questionWriteNaviBar.rightActivateBtn.isActivated = true
        }
    }
    
    /// btn Action set 메서드
    private func setTapBtnAction() {
        
        /// rightActivate Btn Press
        questionWriteNaviBar.rightActivateBtn.press(vibrate: true, for: .touchUpInside) {
            guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            alert.showNadoAlert(vc: self, message: self.confirmAlertMsg, confirmBtnTitle: "네", cancelBtnTitle: "아니요")
            alert.confirmBtn.press {
                if self.isEditState {
                    if let postID = self.postID {
                        self.editClassroomPost(postID: postID, title: self.questionTitleTextField.text ?? "", content: self.questionWriteTextView.text ?? "")
                    }
                } else {
                    // TODO: 게시글 작성 API 연결
                    //                    self.createClassroomPost(majorID: self.majorID, answerID: self.answerID ?? nil, postTypeID: self.questionType?.rawValue ?? 3, title: self.questionTitleTextField.text ?? "", content: self.questionWriteTextView.text ?? "")
                }
            }
        }
        
        /// dismissBtn Press
        questionWriteNaviBar.dismissBtn.press {
            guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            alert.showNadoAlert(vc: self, message: self.dismissAlertMsg, confirmBtnTitle: "계속 작성", cancelBtnTitle: "나갈래요")
            alert.cancelBtn.press {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /// 수정상태인지 아닌지에 따라 Alert Message를 지정하는 메서드
    private func setUpAlertMsgByEditState() {
        confirmAlertMsg =
        """
        글을 올리시겠습니까?
        """
        dismissAlertMsg = isEditState ?
        """
        페이지를 나가면
        수정한 내용이 저장되지 않아요.
        """
        :
        """
        페이지를 나가면
        작성중인 글이 삭제돼요.
        """
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
            textView.text = "선배에게 1:1 질문을 남겨보세요. \n선배가 답변해 줄 거에요!"
            textView.textColor = .gray2
            isTextViewEmpty = true
        }
    }
}

// MARK: - Network
extension WriteQuestionVC {
    private func editClassroomPost(postID: Int, title: String, content: String) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.editPostQuestionAPI(postID: postID, title: title, content: content) { networkResult in
            switch networkResult {
            case .success(_):
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        if let postID = self.postID {
                            self.editClassroomPost(postID: postID, title: self.questionTitleTextField.text ?? "", content: self.questionWriteTextView.text ?? "")
                        }
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
