//
//  SignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/08.
//
// TODO: TextField clear Btn 에셋 나오면 수정

import UIKit
import RxSwift
import RxCocoa

class SignInVC: BaseVC {
    // MARK: Properties
    @IBOutlet weak var emailTextField: NadoTextField!
    @IBOutlet weak var PWTextField: NadoTextField!
    @IBOutlet weak var signInBtn: NadoSunbaeBtn!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailClearBtn: UIButton!
    @IBOutlet weak var PWClearBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpUserdefaultValues()
    }
    
    // MARK: IBAction
    @IBAction func tapSignInBtn(_ sender: UIButton) {
        let nadoSunbaeTBC = NadoSunbaeTBC()
        nadoSunbaeTBC.modalPresentationStyle = .fullScreen
        self.present(nadoSunbaeTBC, animated: true, completion: nil)
    }
    
    @IBAction func tapSignUpBtn(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: AgreeTermsVC.className, bundle: nil).instantiateViewController(withIdentifier: "SignUpNVC") as? UINavigationController else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapFindPWBtn(_ sender: UIButton) {
    }
    
    @IBAction func tapContactBtn(_ sender: UIButton) {
    }
}

// MARK: - UI
extension SignInVC {
    private func configureUI() {
        infoLabel.isHidden = true
        signInBtn.isEnabled = false
        checkEmailIsValid()
        setTextFieldClearBtn(textField: emailTextField, clearBtn: emailClearBtn)
        setTextFieldClearBtn(textField: PWTextField, clearBtn: PWClearBtn)
    }
}

// MARK: Custom Methods
extension SignInVC {
    
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
    
    /// 이메일 유효성 검사
    private func checkEmailIsValid() {
        emailTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                if changedText.contains("@") && changedText.contains(".") {
                    self.signInBtn.isActivated = true
                    self.signInBtn.isEnabled = true
                    self.infoLabel.isHidden = true
                } else {
                    self.infoLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Userdefaults에 값 지정하는 메서드
    private func setUpUserdefaultValues() {
        UserDefaults.standard.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiZW1haWwiOiJrdTVAa29yZWEuYWMua3IiLCJuaWNrbmFtZSI6Imt1NSIsImZpcmViYXNlSWQiOiJJSkdFQjhMOEZaVmY0MVE1OGJTWDVQWkttRUQyIiwiaWF0IjoxNjQyNTI4NzcxLCJleHAiOjE2NDUxMjA3NzEsImlzcyI6Im5hZG9TdW5iYWUifQ.U4qQ-muMpVZv8K8Pi7jryrlc6bL4ObEMgc11L01yBAo", forKey: UserDefaults.Keys.AccessToken)
        UserDefaults.standard.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiZW1haWwiOiJrdTVAa29yZWEuYWMua3IiLCJuaWNrbmFtZSI6Imt1NSIsImZpcmViYXNlSWQiOiJJSkdFQjhMOEZaVmY0MVE1OGJTWDVQWkttRUQyIiwiaWF0IjoxNjQyNTI4NzcxLCJleHAiOjE2NDUxMjA3NzEsImlzcyI6Im5hZG9TdW5iYWUifQ.U4qQ-muMpVZv8K8Pi7jryrlc6bL4ObEMgc11L01yBAo", forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(5, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set("경영학과", forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(126, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set("미진입", forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsReviewed)
    }
}
