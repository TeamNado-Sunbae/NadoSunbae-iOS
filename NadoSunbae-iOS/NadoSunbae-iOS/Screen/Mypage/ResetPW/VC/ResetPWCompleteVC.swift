//
//  ResetPWCompleteVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class ResetPWCompleteVC: BaseVC {
    
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
    
    // MARK: Properties
    var email = ""
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: Custom Methods
    private func isLogin() -> Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.UserID) is Int ? true : false
    }
}

// MARK: - Network
extension ResetPWCompleteVC {
    private func resendEmail(email: String) {
        self.activityIndicator.startAnimating()
        MypageSettingAPI.shared.requestResetPW(email: email) { networkResult in
            switch networkResult {
            case .success:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "메일이 재전송되었습니다.")
            case .requestErr:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
