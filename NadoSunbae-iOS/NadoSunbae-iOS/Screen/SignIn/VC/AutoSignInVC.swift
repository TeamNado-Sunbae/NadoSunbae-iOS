//
//  AutoSignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/16.
//

import UIKit
import FirebaseAnalytics

class AutoSignInVC: BaseVC {
    
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // MARK: Properties
    let email: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.Email) ?? ""
    let PW: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.PW) ?? ""
    let refreshToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.RefreshToken) ?? ""
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presentNextViewAfterSplash()
    }
}

// MARK: UI
extension AutoSignInVC {
    private func configureUI() {
        self.titleImgView.alpha = 0
        self.subTitleLabel.alpha = 0
        self.subTitleLabel.fadeIn(duration: 2)
        self.titleImgView.fadeIn(duration: 2)
    }
}

// MARK: Custom Methods
extension AutoSignInVC {
    private func presentNextViewAfterSplash() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
            guard let nextVC = UIStoryboard.init(name: "OnboardingSB", bundle: nil).instantiateViewController(withIdentifier: OnboardingVC.className) as? OnboardingVC else { return }
            if !UserDefaults.standard.bool(forKey: UserDefaults.Keys.IsOnboarding) {
                nextVC.modalPresentationStyle = .fullScreen
                nextVC.modalTransitionStyle = .crossDissolve
                nextVC.view.layer.speed = 1
                self.present(nextVC, animated: true, completion: nil)
            } else {
                self.requestAutoSignIn()
            }
        }
    }
}

// MARK: Network
extension AutoSignInVC {
    
    /// 자동로그인 요청하는 메서드
    private func requestAutoSignIn() {
        SignAPI.shared.requestSignIn(email: email, PW: PW, deviceToken: UserDefaults.standard.string(forKey: UserDefaults.Keys.FCMTokenForDevice) ?? "") { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? SignInDataModel {
                    self.setUpUserdefaultValues(data: data)
                    self.setUserToken(accessToken: data.accesstoken, refreshToken: data.refreshtoken)
                    let nadoSunbaeTBC = NadoSunbaeTBC()
                    nadoSunbaeTBC.modalPresentationStyle = .fullScreen
                    self.present(nadoSunbaeTBC, animated: true, completion: {
                        nadoSunbaeTBC.selectedIndex = NotificationInfo.shared.isPushComes ? 2 : 0
                        NotificationInfo.shared.isPushComes = false
                    })
                    Analytics.setUserID("\(data.user.userID)")
                    Analytics.setUserProperty("제1전공", forName: data.user.firstMajorName)
                    Analytics.setUserProperty("제2전공", forName: data.user.secondMajorName)
                    FirebaseAnalytics.Analytics.logEvent("AnalyticsEventAutoLogin", parameters: nil)
                }
            default:
                print("Failed Auto SignIn")
                self.navigator?.instantiateVC(destinationViewControllerType: SignInVC.self, useStoryboard: true, storyboardName: "SignInSB", naviType: .present, modalPresentationStyle: .fullScreen) { destination in }
            }
        }
    }
}
