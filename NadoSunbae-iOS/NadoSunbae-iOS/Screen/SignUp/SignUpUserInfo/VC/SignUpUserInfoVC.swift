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
    
    /// 이메일 유효성 검사
    private func checkEmailIsValid() {
        emailTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) {
                    self.changeNadoBtnState(isOn: true, btn: self.checkEmailBtn)
                } else {
                    self.changeNadoBtnState(isOn: false, btn: self.checkEmailBtn)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: IBAction
    @IBAction func tapCheckDuplicateBtn(_ sender: UIButton) {
        // TODO: 중복 검사 실행 후 다시 여기 기능 세팅!
        if true {
            self.nickNameInfoLabel.textColor = .mainDark
            self.nickNameInfoLabel.text = "사용 가능한 닉네임입니다."
            self.nickNameClearBtn.isHidden = true
        } else { // 요기 워닝 떠서 주석처리함
//            self.nickNameInfoLabel.textColor = .red
//            self.nickNameInfoLabel.text = "이미 사용중인 닉네임입니다."
        }
        self.nickNameInfoLabel.isHidden = false
    }
    
    @IBAction func tapCheckEmailBtn(_ sender: UIButton) {
        // TODO: 이메일 확인 검사 실행 후 다시 여기 기능 세팅!
        if true {
            self.emailInfoLabel.textColor = .mainDark
            self.emailInfoLabel.text = "인증 메일이 전송되었습니다."
            self.emailClearBtn.isHidden = true
        } else { // 요기 워닝 떠서 주석처리함
//            self.emailInfoLabel.textColor = .red
//            self.emailInfoLabel.text = "이미 가입된 메일입니다."
        }
        self.emailInfoLabel.isHidden = false
    }
}
