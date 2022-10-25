//
//  SignUpUserInfoVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/11.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class SignUpUserInfoVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var checkDuplicateBtn: NadoSunbaeBtn!
    @IBOutlet weak var checkEmailBtn: NadoSunbaeBtn!
    @IBOutlet weak var nickNameTextField: NadoTextField!
    @IBOutlet weak var nickNameClearBtn: UIButton!
    @IBOutlet weak var emailTextField: NadoTextField!
    @IBOutlet weak var emailClearBtn: UIButton!
    @IBOutlet weak var nickNameRuleLabel: UILabel!
    @IBOutlet weak var nickNameInfoLabel: UILabel!
    @IBOutlet weak var emailInfoLabel: UILabel!
    
    @IBOutlet weak var PWTextField: NadoTextField!
    @IBOutlet weak var PWClearBtn: UIButton!
    @IBOutlet weak var checkPWTextFIeld: NadoTextField!
    @IBOutlet weak var checkPWClearBtn: UIButton!
    @IBOutlet weak var PWRuleLabel: UILabel!
    @IBOutlet weak var PWInfoLabel: UILabel!
    
    @IBOutlet weak var prevBtn: NadoSunbaeBtn!
    @IBOutlet weak var completeBtn: NadoSunbaeBtn!
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    var isCompleteList = [false, false, false]
    var signUpData = SignUpBodyModel()
    var univEmailDomain = UnivEmailDomainDataModel(email: "")
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        getUnivEmailDomain(univID: signUpData.universityID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    // MARK: IBAction
    @IBAction func tapCheckDuplicateBtn(_ sender: UIButton) {
        view.endEditing(true)
        requestCheckNickName(nickName: self.nickNameTextField.text ?? "")
        self.nickNameInfoLabel.isHidden = false
    }
    
    @IBAction func tapCheckEmailBtn(_ sender: UIButton) {
        view.endEditing(true)
        requestCheckEmail(email: self.emailTextField.text ?? "")
        self.emailInfoLabel.isHidden = false
    }
    
    @IBAction func tapPrevBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapCompleteBtn(_ sender: UIButton) {
        setSignUpData()
        requestSignUp(userData: signUpData)
        FirebaseAnalytics.Analytics.logEvent(AnalyticsEventSignUp, parameters: nil)
    }
    
    @IBAction func tapDismissBtn(_ sender: UIButton) {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        alert.cancelBtn.press {
            self.dismiss(animated: true, completion: nil)
        }
        alert.showNadoAlert(vc: self, message: """
페이지를 나가면
회원가입이 취소돼요.
"""
                            , confirmBtnTitle: "계속 작성", cancelBtnTitle: "나갈래요")
    }
}

// MARK: - Custom Method
extension SignUpUserInfoVC {
    private func configureUI() {
        checkDuplicateBtn.setTitleWithStyle(title: "중복 확인", size: 14, weight: .semiBold)
        checkEmailBtn.setTitleWithStyle(title: "중복 확인", size: 14, weight: .semiBold)
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
        emailTextField.placeholder = "입력 전"
        changePWInfoLabelState()
        checkEmailIsValid()
        checkNickNameIsValid()
        prevBtn.setBackgroundColor(.mainLight, for: .normal)
        completeBtn.isEnabled = false
        PWTextField.delegate = self
        checkPWTextFIeld.delegate = self
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
                switch textField {
                case self.nickNameTextField:
                    self.changeNadoBtnState(isOn: false, btn: self.checkDuplicateBtn)
                    self.isCompleteList[0] = false
                case self.emailTextField:
                    self.changeNadoBtnState(isOn: false, btn: self.checkEmailBtn)
                    self.isCompleteList[1] = false
                default:
                    break
                }
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
        checkIsCompleted()
    }
    
    /// Label color 변경 함수
    private func changeLabelColor(isOK: Bool, label: UILabel) {
        label.textColor = isOK ? .gray3 : .red
    }
    
    /// 비밀번호 확인 함수
    private func changePWInfoLabelState() {
        
        /// 비밀번호 유효성 검사
        PWTextField.rx.text
            .orEmpty
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                let regex = "^(?=.*[A-Za-z])(?=.*[0-9]).{6,20}"
                if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) {
                    self.checkPWTextFIeld.isUserInteractionEnabled = true
                    self.changeLabelColor(isOK: true, label: self.PWRuleLabel)
                } else {
                    self.checkPWTextFIeld.isUserInteractionEnabled = false
                    self.changeLabelColor(isOK: false, label: self.PWRuleLabel)
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
                    self.isCompleteList[2] = true
                } else {
                    self.PWInfoLabel.text = "비밀번호가 일치하지 않습니다."
                    self.PWInfoLabel.textColor = .red
                    self.isCompleteList[2] = false
                }
                self.checkIsCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    /// 닉네임 유효성 검사
    private func checkNickNameIsValid() {
        nickNameTextField.rx.text
            .orEmpty
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.isCompleteList[0] = false
                if changedText.count > 0 {
                    self.nickNameInfoLabel.text = ""
                    let regex = "[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9]{2,8}"
                    if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) {
                        self.changeLabelColor(isOK: true, label: self.nickNameRuleLabel)
                        self.changeNadoBtnState(isOn: true, btn: self.checkDuplicateBtn)
                    } else {
                        self.changeLabelColor(isOK: false, label: self.nickNameRuleLabel)
                        self.changeNadoBtnState(isOn: false, btn: self.checkDuplicateBtn)
                    }
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
                self.isCompleteList[1] = false
                self.emailInfoLabel.text = ""
                let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) && changedText.contains(self.univEmailDomain.email) {
                    self.changeNadoBtnState(isOn: true, btn: self.checkEmailBtn)
                } else {
                    self.changeNadoBtnState(isOn: false, btn: self.checkEmailBtn)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 모든 정보가 정상적으로 기입됐는지 검사
    private func checkIsCompleted() {
        if isCompleteList == [true, true, true] {
            completeBtn.isActivated = true
            completeBtn.isEnabled = true
        } else {
            completeBtn.isActivated = false
            completeBtn.isEnabled = false
        }
    }
    
    /// SignUp을 위한 Data 세팅
    private func setSignUpData() {
        signUpData.nickName = self.nickNameTextField.text ?? ""
        signUpData.email = self.emailTextField.text ?? ""
        signUpData.PW = self.checkPWTextFIeld.text ?? ""
    }
}

// MARK: - Network
extension SignUpUserInfoVC {
    
    /// 학교 이메일 도메인 요청하는 메소드
    private func getUnivEmailDomain(univID: Int) {
        self.activityIndicator.startAnimating()
        SignAPI.shared.getUnivEmailDomain(univID: univID) { networkResult in
            self.activityIndicator.stopAnimating()
            switch networkResult {
            case .success(let res):
                if let domain = res as? UnivEmailDomainDataModel {
                    self.univEmailDomain = domain
                    self.emailTextField.placeholder = self.univEmailDomain.email
                }
            default:
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
    
    /// 닉네임 중복 확인 메소드
    private func requestCheckNickName(nickName: String) {
        self.activityIndicator.startAnimating()
        SignAPI.shared.checkNickNameDuplicate(nickName: nickName) { networkResult in
            switch networkResult {
            case .success:
                self.activityIndicator.stopAnimating()
                self.nickNameInfoLabel.textColor = .mainDark
                self.nickNameInfoLabel.text = "사용 가능한 닉네임입니다."
                self.nickNameClearBtn.isHidden = true
                self.isCompleteList[0] = true
                self.checkIsCompleted()
            case .requestErr(let success):
                self.activityIndicator.stopAnimating()
                if success is Bool {
                    self.nickNameInfoLabel.textColor = .red
                    self.nickNameInfoLabel.text = "이미 사용중인 닉네임입니다."
                    self.isCompleteList[0] = false
                    self.checkIsCompleted()
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
                self.checkIsCompleted()
            }
        }
    }
    
    /// 이메일 중복 확인 메소드
    private func requestCheckEmail(email: String) {
        self.activityIndicator.startAnimating()
        SignAPI.shared.checkEmailDuplicate(email: email) { networkResult in
            switch networkResult {
            case .success:
                self.activityIndicator.stopAnimating()
                self.emailInfoLabel.textColor = .mainDark
                self.emailInfoLabel.text = "사용 가능한 이메일입니다."
                self.emailClearBtn.isHidden = true
                self.isCompleteList[1] = true
                self.checkIsCompleted()
            case .requestErr(let success):
                self.activityIndicator.stopAnimating()
                if success is Bool {
                    self.emailInfoLabel.textColor = .red
                    self.emailInfoLabel.text = "이미 가입된 메일입니다."
                    self.isCompleteList[1] = false
                    self.checkIsCompleted()
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
                self.checkIsCompleted()
            }
        }
    }
    
    /// 회원가입 요청 메소드
    private func requestSignUp(userData: SignUpBodyModel) {
        self.activityIndicator.startAnimating()
        SignAPI.shared.requestSignUp(userData: userData) { networkResult in
            switch networkResult {
            case .success(let res):
                self.activityIndicator.stopAnimating()
                if res is SignUpDataModel {
                    guard let mailCompleteVC = UIStoryboard.init(name: MailCompleteVC.className, bundle: nil).instantiateViewController(withIdentifier: MailCompleteVC.className) as? MailCompleteVC else { return }
                    mailCompleteVC.completeType = .signUp
                    mailCompleteVC.email = userData.email
                    mailCompleteVC.PW = userData.PW
                    mailCompleteVC.modalPresentationStyle = .fullScreen
                    self.present(mailCompleteVC, animated: true, completion: nil)
                }
            case .requestErr(let msg):
                self.activityIndicator.stopAnimating()
                if let message = msg as? String {
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
}

extension SignUpUserInfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addKeyboardObserver()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        removeKeyboardObserver()
    }
}

// MARK: - Keyboard
extension SignUpUserInfoVC {
    
    /// Keyboard Observer add 메서드
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == PWTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= 100
                }
            })
        }
        return true
    }
    
    /// 키보드 return 눌렀을 때 Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == PWTextField {
            checkPWTextFIeld.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @objc
    private func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    /// Keyboard Observer remove 메서드
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
