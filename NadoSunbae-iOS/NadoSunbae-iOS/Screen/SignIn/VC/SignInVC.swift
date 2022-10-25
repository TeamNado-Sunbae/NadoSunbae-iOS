//
//  SignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAnalytics

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
        setUpNotificationPermission()
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
        self.navigator?.instantiateVC(destinationViewControllerType: SignUpNC.self, useStoryboard: true, storyboardName: AgreeTermsVC.className, naviType: .present, modalPresentationStyle: .fullScreen) { destination in }
    }
    
    @IBAction func tapFindPWBtn(_ sender: UIButton) {
        self.navigator?.instantiateVC(destinationViewControllerType: ResetPWVC.self, useStoryboard: true, storyboardName: ResetPWVC.className, naviType: .present, modalPresentationStyle: .fullScreen) { destination in }
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
        checkEmailPWIsValid()
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
                self.signInBtn.isActivated = false
                self.signInBtn.isEnabled = false
            }
            .disposed(by: disposeBag)
    }
    
    /// 이메일, 비밀번호 상태에 따라 로그인 버튼 상태 판단 메서드
    private func checkEmailPWIsValid() {
        emailTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                if changedText.count == 0 {
                    self.signInBtn.isActivated = false
                    self.signInBtn.isEnabled = false
                } else {
                    if changedText.contains("@") && changedText.contains(".") && !(self.PWTextField.text?.isEmpty ?? false) {
                        self.signInBtn.isActivated = true
                        self.signInBtn.isEnabled = true
                    } else {
                        self.signInBtn.isActivated = false
                        self.signInBtn.isEnabled = false
                    }
                }
            })
            .disposed(by: disposeBag)
        
        PWTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                if self.emailTextField.text?.contains("@") ?? false && self.emailTextField.text?.contains(".") ?? false {
                    self.signInBtn.isActivated = !(changedText.isEmpty)
                    self.signInBtn.isEnabled = !(changedText.isEmpty)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Userdefaults에 값 지정하는 메서드
    private func setUpUserdefaultValuesForSignIn(data: SignInDataModel) {
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsOnboarding)
        UserDefaults.standard.set(emailTextField.text, forKey: UserDefaults.Keys.Email)
        UserDefaults.standard.set(PWTextField.text, forKey: UserDefaults.Keys.PW)
        setUpUserdefaultValues(data: data)
    }
    
    private func doForIsEmailVerified(data: SignInDataModel) {
        self.setUpUserdefaultValuesForSignIn(data: data)
        let nadoSunbaeTBC = NadoSunbaeTBC()
        nadoSunbaeTBC.modalPresentationStyle = .fullScreen
        self.present(nadoSunbaeTBC, animated: true, completion: nil)
    }
    
    private func doForIsNotEmailVerified() {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        
        alert.showNadoAlert(vc: self, message: "학교 이메일 인증을 완료해야\n로그인이 가능합니다.", confirmBtnTitle: "메일 재전송", cancelBtnTitle: "닫기")
        alert.confirmBtn.press(vibrate: true, for: .touchUpInside) {
            self.resendSignUpMail(email: self.emailTextField.text ?? "", PW: self.PWTextField.text ?? "")
            alert.dismiss(animated: true, completion: nil)
        }
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
                    self.doForIsEmailVerified(data: data)
                    self.setUserToken(accessToken: data.accesstoken, refreshToken: data.refreshtoken)
                    if env() == .development {
                        debugPrint("SIGN IN ACCESS TOKEN: \(data.accesstoken)")
                    }
                    Analytics.setUserID("\(data.user.userID)")
                    Analytics.setUserProperty("제1전공", forName: data.user.firstMajorName)
                    Analytics.setUserProperty("제2전공", forName: data.user.secondMajorName)
                    FirebaseAnalytics.Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                }
            case .requestErr(let res):
                self.activityIndicator.stopAnimating()
                if let message = res as? String {
                    self.infoLabel.text = "아이디 또는 비밀번호가 잘못되었어요."
                    self.infoLabel.isHidden = false
                    print("requestSignIn request err", message)
                } else if res is Bool {
                    self.doForIsNotEmailVerified()
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
    
    /// 회원가입 인증 메일 재전송
    private func resendSignUpMail(email: String, PW: String) {
        SignAPI.shared.resendSignUpMail(email: email, PW: PW) { networkResult in
            switch networkResult {
            case .success:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.resendMail.alertMessage)
            case .requestErr:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension SignInVC: UNUserNotificationCenterDelegate {
    
    /// 푸시 권한 요청하는 메서드
    func setUpNotificationPermission() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        /// 푸시 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if granted {
                    /// APN에 토큰 매핑하는 프로세스
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        )
    }
}
