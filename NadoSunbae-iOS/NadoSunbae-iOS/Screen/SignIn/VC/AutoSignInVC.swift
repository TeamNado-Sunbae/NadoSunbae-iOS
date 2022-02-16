//
//  AutoSignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/16.
//

import UIKit

class AutoSignInVC: BaseVC {
    
    // MARK: Properties
    let email: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.Email) ?? ""
    let PW: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.PW) ?? ""
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: Custom Methods
extension AutoSignInVC {
    
    /// Userdefaults에 값 지정하는 메서드
    private func setUpUserdefaultValues(data: SignInDataModel) {
        UserDefaults.standard.set(data.accesstoken, forKey: UserDefaults.Keys.AccessToken)
        UserDefaults.standard.set(data.accesstoken, forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(data.user.firstMajorID, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set(data.user.firstMajorName, forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(data.user.secondMajorID, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set(data.user.secondMajorName, forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(data.user.isReviewed, forKey: UserDefaults.Keys.IsReviewed)
        UserDefaults.standard.set(data.user.userID, forKey: UserDefaults.Keys.UserID)
    }
}

// MARK: Network
extension AutoSignInVC {
    
    /// 로그인 요청하는 메서드
    private func requestSignIn() {
        self.activityIndicator.startAnimating()
        SignAPI.shared.signIn(email: email, PW: PW, deviceToken: UserDefaults.standard.value(forKey: UserDefaults.Keys.FCMTokenForDevice) as! String) { networkResult in
            switch networkResult {
            case .success(let res):
                self.activityIndicator.stopAnimating()
                if let data = res as? SignInDataModel {
                    self.setUpUserdefaultValues(data: data)
                    let nadoSunbaeTBC = NadoSunbaeTBC()
                    nadoSunbaeTBC.modalPresentationStyle = .fullScreen
                    self.present(nadoSunbaeTBC, animated: true, completion: nil)
                }
            default:
                self.activityIndicator.stopAnimating()
                print("Failed Auto SignIn")
                guard let signInVC = self.storyboard?.instantiateViewController(withIdentifier: SignInVC.className) as? SignInVC else { return }
                self.present(signInVC, animated: true, completion: nil)
            }
        }
    }
}
