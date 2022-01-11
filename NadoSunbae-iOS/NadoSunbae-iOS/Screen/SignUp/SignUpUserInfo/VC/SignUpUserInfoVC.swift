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
            setTextFieldClearBtn(textField: textField, clearBtn: btn)
        }
        
        setCheckBtnState(textField: nickNameTextField, checkBtn: checkDuplicateBtn)
        changePWInfoLabelState()
        checkEmailIsValid()
        prevBtn.setBackgroundColor(.mainLight, for: .normal)
    }
    
    /// textField-btn 에 clear 기능 세팅하는 함수
    private func setTextFieldClearBtn(textField: UITextField, clearBtn: UIButton) {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                clearBtn.isHidden = changedText != "" ? false : true
            })
            .disposed(by: disposeBag)
        
        /// Clear 버튼 액션
        clearBtn.rx.tap
            .bind {
                textField.text = ""
                clearBtn.isHidden = true
            }
            .disposed(by: disposeBag)
    }
    
    /// textField가 채워져 있는지에 따라 Btn 상태 변경하는 함수
    private func setCheckBtnState(textField: UITextField, checkBtn: NadoSunbaeBtn) {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.changeNadoBtnState(isOn: changedText != "", btn: checkBtn)
            })
            .disposed(by: disposeBag)
        
        nickNameClearBtn.rx.tap
            .bind {
                self.changeNadoBtnState(isOn: false, btn: self.checkDuplicateBtn)
            }
            .disposed(by: disposeBag)
        
        emailClearBtn.rx.tap
            .bind {
                self.changeNadoBtnState(isOn: false, btn: self.checkEmailBtn)
            }
            .disposed(by: disposeBag)
    }
    
    /// NadoSunbae 버튼의 상태 변경 함수
    private func changeNadoBtnState(isOn: Bool, btn: NadoSunbaeBtn) {
        btn.isActivated = isOn ? true : false
        btn.backgroundColor = isOn ? .mainLight : .gray1
        btn.isEnabled = isOn ? true : false
    }
    
    /// 비밀번호 확인 함수
    private func changePWInfoLabelState() {
        
        /// 비밀번호 유효성 검사
        PWTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                let regex = "^(?=.*[A-Za-z])(?=.*[0-9]).{6,20}"
                if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) {
                    self.checkPWTextFIeld.isUserInteractionEnabled = true
                } else {
                    self.checkPWTextFIeld.isUserInteractionEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        /// 비밀번호 일치 검사
        checkPWTextFIeld.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.PWInfoLabel.isHidden = changedText == "" ? true : false
                if changedText == self.PWTextField.text {
                    self.PWInfoLabel.text = "비밀번호가 일치합니다."
                    self.PWInfoLabel.textColor = .mainDark
                } else {
                    self.PWInfoLabel.text = "비밀번호가 일치하지 않습니다."
                    self.PWInfoLabel.textColor = .red
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: IBAction
}
