//
//  SignUpUserInfoVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/11.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpUserInfoVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var checkDuplicateBtn: NadoSunbaeBtn!
    @IBOutlet weak var checkEmailBtn: NadoSunbaeBtn!
    @IBOutlet weak var nickNameTextField: NadoTextField!
    @IBOutlet weak var nickNameClearBtn: UIButton!
    @IBOutlet weak var emailTextField: NadoTextField!
    @IBOutlet weak var emailClearBtn: UIButton!
    @IBOutlet weak var nickNameInfoLabel: UILabel!
    @IBOutlet weak var emailInfoLabel: UILabel!
    
    @IBOutlet weak var PWTextField: NadoTextField!
    @IBOutlet weak var PWClearBtn: UIButton!
    @IBOutlet weak var checkPWTextFIeld: NadoTextField!
    @IBOutlet weak var checkPWClearBtn: UIButton!
    @IBOutlet weak var PWInfoLabel: UILabel!
    
    @IBOutlet weak var prevBtn: NadoSunbaeBtn!
    @IBOutlet weak var completeBtn: NadoSunbaeBtn!
    
    let disposeBag = DisposeBag()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Custom Method
    private func configureUI() {
        checkDuplicateBtn.setTitleWithStyle(title: "중복 확인", size: 14, weight: .semiBold)
        checkEmailBtn.setTitleWithStyle(title: "이메일 확인", size: 14, weight: .semiBold)
        [checkDuplicateBtn, checkEmailBtn].forEach { btn in
            btn?.makeRounded(cornerRadius: 8.adjusted)
            btn?.isEnabled = false
        }
        
        [nickNameInfoLabel, emailInfoLabel, PWInfoLabel].forEach { label in
            label?.isHidden = true
        }
        
        [(nickNameTextField, nickNameClearBtn), (emailTextField, emailClearBtn), (PWTextField, PWClearBtn), (checkPWTextFIeld, checkPWClearBtn)].forEach { (textField, btn) in
            setTextFieldClearBtn(textField: textField, btn: btn)
        }
        prevBtn.setBackgroundColor(.mainLight, for: .normal)
    }
    
    /// textField-btn 에 clear 기능 세팅하는 함수
    private func setTextFieldClearBtn(textField: UITextField, btn: UIButton) {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                btn.isHidden = changedText != "" ? false : true
            })
            .disposed(by: disposeBag)
        
        /// Clear 버튼 액션
        btn.rx.tap
            .bind {
                textField.text = ""
                btn.isHidden = true
            }
            .disposed(by: disposeBag)
    }
    
    private func judgeCheckBtnState() {
        //        checkDuplicateBtn.isActivated = true
        //        checkDuplicateBtn.setBackgroundColor(.mainLight, for: .normal)
    }
    
    // MARK: IBAction
}
