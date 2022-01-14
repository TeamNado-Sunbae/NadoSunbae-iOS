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

class WriteQuestionVC: UIViewController {
    
    // MARK: Properties
    private let questionWriteNaviBar = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .dismissWithNadoBtn)
        $0.configureTitleLabel(title: "1:1 질문 작성")
    }
    
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
    
    private let questionWriteTextView = NadoTextView().then {
        $0.setDefaultStyle(placeholderText: "선배에게 1:1 질문을 남겨보세요.\n선배가 답변해 줄 거에요!")
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTextViewDelegate()
        setTapBtnAction()
    }
}

// MARK: - UI
extension WriteQuestionVC {
    private func configureUI() {
        view.addSubviews([questionWriteNaviBar, questionTitleTextField, textHighlightView, contentHeaderLabel, questionWriteTextView])
        
        questionWriteNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        questionTitleTextField.snp.makeConstraints {
            $0.top.equalTo(questionWriteNaviBar.snp.bottom).offset(24)
            $0.leading.equalTo(view).offset(24)
            $0.trailing.equalTo(view).offset(-24)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-58)
        }
    }
}

// MARK: - Custom Method
extension WriteQuestionVC {
    
    private func setTextViewDelegate() {
        questionWriteTextView.delegate = self
    }
    /// textField가 채워져 있는지에 따라 Btn 상태 변경하는 함수
    private func setCheckBtnState(textField: UITextField, checkBtn: NadoSunbaeBtn) {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                //                self.changeNadoBtnState(isOn: changedText != "", btn: checkBtn)
            })
            .disposed(by: disposeBag)
        
        //        nickNameClearBtn.rx.tap
        //            .bind {
        //                self.changeNadoBtnState(isOn: false, btn: self.checkDuplicateBtn)
        //            }
        //            .disposed(by: disposeBag)
        //
        //        emailClearBtn.rx.tap
        //            .bind {
        //                self.changeNadoBtnState(isOn: false, btn: self.checkEmailBtn)
        //            }
        //            .disposed(by: disposeBag)
    }
    
    private func setTapBtnAction() {
        questionWriteNaviBar.rightActivateBtn.press {
            print("press")
            // TODO: Alert 띄우기
        }
        
        questionWriteNaviBar.dismissBtn.press {
            print("dismiss")
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITextViewDelegate
extension WriteQuestionVC: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async() {
            scrollView.scrollIndicators.vertical?.backgroundColor = .scrollMint
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray2 {
            textView.text = nil
            textView.textColor = .mainText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "선배에게 1:1 질문을 남겨보세요.\n선배가 답변해 줄 거에요!"
            textView.textColor = .gray2
        }
    }
}
