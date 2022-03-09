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
    
    /// 앱 최신 버전 조회 후 alert 띄우는 함수
    func getLatestVersion() {
        getAppLink { response in
            if AppVersion.shared.latestVersion != AppVersion.shared.currentVersion {
                guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
                alert.confirmBtn.press {
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/1605763068"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                alert.cancelBtn.press {
                    self.dismiss(animated: true, completion: nil)
                }
                alert.showNadoAlert(vc: self, message:
        """
        유저들의 의견을 반영하여
        사용성을 개선했어요.
        지금 바로 업데이트해보세요!
        """
                                    , confirmBtnTitle: "업데이트", cancelBtnTitle: "다음에 하기")
            }
        }
    }
    
    /// 권한에 따른 제한 알럿 띄워주는 함수
    func showRestrictionAlert() {
        guard let restrictionAlert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        
        /// 후기 작성 버튼 클릭시 후기 작성 페이지로 이동
        restrictionAlert.confirmBtn.press {
            let ReviewWriteSB = UIStoryboard.init(name: "ReviewWriteSB", bundle: nil)
            guard let nextVC = ReviewWriteSB.instantiateViewController(withIdentifier: ReviewWriteVC.className) as? ReviewWriteVC else { return }
            
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
        restrictionAlert.showNadoAlert(vc: self, message: "내 학과 후기를 작성해야\n이용할 수 있는 기능이에요.", confirmBtnTitle: "후기 작성", cancelBtnTitle: "다음에 작성")
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
                    self.setUserToken(accessToken: data.accesstoken, refreshToken: data.accesstoken)
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
    
    /// 앱 최신 버전 조회
    func getLatestVersion(completion: @escaping (GetLatestVersionResponseModel) -> (Void)) {
        self.activityIndicator.startAnimating()
        MypageSettingAPI.shared.getLatestVersion { networkResult in
            switch networkResult {
            case .success(let res):
                if let response = res as? GetLatestVersionResponseModel {
                    completion(response)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getLatestVersion { response in
                            completion(response)
                        }
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
