//
//  SignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

class SignInVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var emailTextField: NadoTextField!
    @IBOutlet weak var PWTextField: NadoTextField!
    @IBOutlet weak var signInBtn: NadoSunbaeBtn!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailClearBtn: UIButton!
    @IBOutlet weak var PWClearBtn: UIButton!
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    var kakaoLink = ""
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getAppLink { appLink in
            self.kakaoLink = appLink.kakaoTalkChannel
        }
    }
    
    // MARK: @IBAction
    @IBAction func tapSignInBtn(_ sender: UIButton) {
        requestSignIn()
    }
    
    @IBAction func tapSignUpBtn(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: AgreeTermsVC.className, bundle: nil).instantiateViewController(withIdentifier: "SignUpNVC") as? UINavigationController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapFindPWBtn(_ sender: UIButton) {
        guard let resetPWVC = UIStoryboard.init(name: ResetPWVC.className, bundle: nil).instantiateViewController(withIdentifier: ResetPWVC.className) as? ResetPWVC else { return }
        resetPWVC.modalPresentationStyle = .fullScreen
        self.present(resetPWVC, animated: true, completion: nil)
    }
    
    @IBAction func tapContactBtn(_ sender: UIButton) {
        if let url = URL(string: kakaoLink) {
            UIApplication.shared.open(url, options: [:])
        }
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
                if changedText.count == 0 {
                    self.infoLabel.isHidden = true
                    self.signInBtn.isActivated = false
                    self.signInBtn.isEnabled = false
                } else {
                    if changedText.contains("@") && changedText.contains(".") {
                        self.signInBtn.isActivated = true
                        self.signInBtn.isEnabled = true
                        self.infoLabel.isHidden = true
                    } else {
                        self.infoLabel.isHidden = false
                        self.signInBtn.isActivated = false
                        self.signInBtn.isEnabled = false
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Userdefaults에 값 지정하는 메서드
    private func setUpUserdefaultValues(data: SignInDataModel) {
        UserDefaults.standard.set(data.accesstoken, forKey: UserDefaults.Keys.AccessToken)
        UserDefaults.standard.set(data.refreshtoken, forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(data.user.firstMajorID, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set(data.user.firstMajorName, forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(data.user.secondMajorID, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set(data.user.secondMajorName, forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(data.user.isReviewed, forKey: UserDefaults.Keys.IsReviewed)
        UserDefaults.standard.set(data.user.userID, forKey: UserDefaults.Keys.UserID)
        UserDefaults.standard.set(emailTextField.text, forKey: UserDefaults.Keys.Email)
        UserDefaults.standard.set(PWTextField.text, forKey: UserDefaults.Keys.PW)
    }
}

// MARK: - Network
extension SignInVC {
    
    /// 로그인 요청하는 메서드
    private func requestSignIn() {
        self.activityIndicator.startAnimating()
        SignAPI.shared.requestSignIn(email: emailTextField.text ?? "", PW: PWTextField.text ?? "", deviceToken: UserDefaults.standard.value(forKey: UserDefaults.Keys.FCMTokenForDevice) as! String) { networkResult in
            switch networkResult {
            case .success(let res):
                self.activityIndicator.stopAnimating()
                if let data = res as? SignInDataModel {
                    self.setUpUserdefaultValues(data: data)
                    let nadoSunbaeTBC = NadoSunbaeTBC()
                    nadoSunbaeTBC.modalPresentationStyle = .fullScreen
                    self.present(nadoSunbaeTBC, animated: true, completion: nil)
                }
            case .requestErr(let msg):
                self.activityIndicator.stopAnimating()
                if let message = msg as? String {
                    self.infoLabel.text = message
                    self.infoLabel.isHidden = false
                    print("requestSignIn request err", message)
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
