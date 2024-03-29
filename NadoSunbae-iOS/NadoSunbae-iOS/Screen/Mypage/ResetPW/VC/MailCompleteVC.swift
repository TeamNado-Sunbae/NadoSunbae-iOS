//
//  ResetPWCompleteVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

enum MailCompleteType {
    case resetPW
    case signUp
}

class MailCompleteVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var goSignInBtn: NadoSunbaeBtn! {
        didSet {
            goSignInBtn.isActivated = true
            goSignInBtn.isEnabled = true
            goSignInBtn.press {
                guard let signInVC = UIStoryboard.init(name: "SignInSB", bundle: nil).instantiateViewController(withIdentifier: SignInVC.className) as? SignInVC else { return }
                if self.isLogin() {
                    self.navigationController?.pushViewController(signInVC, animated: true)
                } else {
                    signInVC.modalPresentationStyle = .fullScreen
                    self.present(signInVC, animated: true, completion: nil)
                }
            }
        }
    }
    @IBOutlet weak var resendBtn: UIButton! {
        didSet {
            resendBtn.press {
                self.resendEmail(email: self.email)
            }
        }
    }
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            switch completeType {
            case .resetPW:
                infoLabel.text = "비밀번호를 재설정할 수 있는 링크가 전송되었습니다."
            case .signUp:
                infoLabel.text = "학교 이메일 인증 링크가 전송되었어요.\n인증을 실시하면 회원가입이 완료됩니다."
            }
        }
    }
    
    // MARK: Properties
    var email = ""
    var PW = ""
    var completeType: MailCompleteType = .resetPW
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: MailCompleteVC.className)
    }
    
    // MARK: Custom Methods
    private func isLogin() -> Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.UserID) is Int ? true : false
    }
}

// MARK: - Network
extension MailCompleteVC {
    private func resendEmail(email: String) {
        self.activityIndicator.startAnimating()
        switch completeType {
        case .resetPW:
            self.makeAnalyticsEvent(eventName: .remail_button, parameterValue: "find_passward_view")
            MypageSettingAPI.shared.requestResetPW(email: email) { networkResult in
                switch networkResult {
                case .success:
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.resendMail.alertMessage)
                case .requestErr(let res):
                    if let message = res as? String {
                        debugPrint(message)
                        self.activityIndicator.stopAnimating()
                        self.makeAlert(title: AlertType.networkError.alertMessage)
                    } else if res is Bool {
                        self.updateAccessToken { _ in
                            self.resendEmail(email: email)
                        }
                    }
                default:
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                }
            }
        case .signUp:
            self.makeAnalyticsEvent(eventName: .remail_button, parameterValue: "sign_up_view")
            SignAPI.shared.resendSignUpMail(email: email, PW: PW) { networkResult in
                switch networkResult {
                case .success:
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.resendMail.alertMessage)
                case .requestErr(let res):
                    if let message = res as? String {
                        debugPrint(message)
                        self.activityIndicator.stopAnimating()
                        self.makeAlert(title: AlertType.networkError.alertMessage)
                    } else if res is Bool {
                        self.updateAccessToken { _ in
                            self.resendEmail(email: email)
                        }
                    }
                default:
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                }
            }
        }
    }
}
