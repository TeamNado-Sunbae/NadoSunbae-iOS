//
//  BaseVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class BaseVC: UIViewController {
    
    // MARK: Properties
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = view.center
        
        // 기타 옵션
        activityIndicator.color = .mainDefault
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
    }
}

// MARK: - Custom Methods
extension BaseVC {
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// 화면 터치시 키보드 내리는 메서드
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// 로그인/자동로그인 시 토큰을 싱글톤에 저장하는 메서드
    func setUserToken(accessToken: String, refreshToken: String) {
        UserToken.shared.accessToken = accessToken
        UserToken.shared.refreshToken = refreshToken
    }
    
    /// 토큰 갱신, 자동로그인 시 UserDefaults에 값 저장하는 메서드
    func setUpUserdefaultValues(data: SignInDataModel) {
        UserDefaults.standard.set(data.accesstoken, forKey: UserDefaults.Keys.AccessToken)
        UserDefaults.standard.set(data.refreshtoken, forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(data.user.firstMajorID, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set(data.user.firstMajorName, forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(data.user.secondMajorID, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set(data.user.secondMajorName, forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(data.user.isReviewed, forKey: UserDefaults.Keys.IsReviewed)
        UserDefaults.standard.set(data.user.userID, forKey: UserDefaults.Keys.UserID)
    }
    
    /// 로그아웃 시 UserDefaults 지우는 함수
    private func setRemoveUserdefaultValues() {
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.AccessToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.IsReviewed)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.UserID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.Email)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.PW)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BaseVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIButton)
    }
}

// MARK: - Network
extension BaseVC {
    
    /// 앱 링크 조회
    func getAppLink(completion: @escaping (AppLinkResponseModel) -> (Void)) {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.getAppLink { networkResult in
            switch networkResult {
            case .success(let res):
                if let response = res as? AppLinkResponseModel {
                    completion(response)
                }
                self.activityIndicator.stopAnimating()
            case .requestErr(let msg):
                if let message = msg as? String {
                    print("request err: ", message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// access token 갱신
    func updateAccessToken(completion: @escaping (Bool) -> (Void)) {
        SignAPI.shared.updateToken(refreshToken: UserDefaults.standard.string(forKey: UserDefaults.Keys.RefreshToken) ?? "") { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? SignInDataModel {
                    self.setUpUserdefaultValues(data: data)
                    completion(true)
                }
            default:
                print("Failed update Access Token")
                self.setRemoveUserdefaultValues()
                guard let signInVC = UIStoryboard.init(name: "SignInSB", bundle: nil).instantiateViewController(withIdentifier: SignInVC.className) as? SignInVC else { return }
                signInVC.modalPresentationStyle = .fullScreen
                self.present(signInVC, animated: true, completion: nil)
            }
        }
    }
}
