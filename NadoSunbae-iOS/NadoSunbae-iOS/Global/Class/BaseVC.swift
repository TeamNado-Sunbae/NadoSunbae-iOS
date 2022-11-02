//
//  BaseVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit
import FirebaseAnalytics
import SafariServices

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
    var navigator: Navigator?
    var minorUpdateMessage: String?
    var majorUpdateMessage: String?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        navigator = Navigator(vc: self)
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
    
    /// 토큰 갱신, 자동로그인 시 UserDefaults, Singleton에 값 저장하는 메서드
    func setUpUserdefaultValues(data: SignInDataModel) {
        UserDefaults.standard.set(data.accesstoken, forKey: UserDefaults.Keys.AccessToken)
        UserDefaults.standard.set(data.refreshtoken, forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(data.user.firstMajorID, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set(data.user.firstMajorName, forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(data.user.secondMajorID, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set(data.user.secondMajorName, forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(data.user.userID, forKey: UserDefaults.Keys.UserID)
        UserDefaults.standard.set(data.user.universityID, forKey: UserDefaults.Keys.univID)
        UserPermissionInfo.shared.isReviewed = data.user.isReviewed
        UserPermissionInfo.shared.isUserReported = data.user.isUserReported
        UserPermissionInfo.shared.isReviewInappropriate = data.user.isReviewInappropriate
        UserPermissionInfo.shared.permissionMsg = data.user.permissionMsg
    }
    
    /// 로그아웃 시 UserDefaults 지우는 함수
    func setRemoveUserdefaultValues() {
        MajorInfo.shared.selectedMajorID = nil
        MajorInfo.shared.selectedMajorName = nil
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.AccessToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.UserID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.Email)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.PW)
    }
    
    /// 앱 최신 버전 조회 후 alert 띄우는 함수
    func getLatestVersion(completion: @escaping () -> ()) {
        getLatestVersion { [weak self] response in
            guard let self = self else { return }
            guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            alert.view.backgroundColor = .init(white: 1, alpha: 0.5)
            alert.confirmBtn.press {
                if let url = URL(string: "itms-apps://itunes.apple.com/app/1605763068"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                self.makeAnalyticsEvent(eventName: .update_opt, parameterValue: "update_now")
            }
            alert.cancelBtn.press {
                self.makeAnalyticsEvent(eventName: .update_opt, parameterValue: "update_later")
                completion()
            }
            if env() == .development || env() == .qa {
                completion()
            } else {
                
                /// 앞자리가 최신 버전보다 크다면 강제 업데이트 알럿
                if AppVersion.shared.latestVersion.prefix(1) > AppVersion.shared.currentVersion.prefix(1) {
                    alert.showNadoAlert(vc: self, message: self.majorUpdateMessage ?? AlertType.forceUpdate.alertMessage, confirmBtnTitle: "나도선배 앱 업데이트", cancelBtnTitle: "", type: .withSingleBtn)
                } else if AppVersion.shared.latestVersion.prefix(1) == AppVersion.shared.currentVersion.prefix(1) {
                    if AppVersion.shared.latestVersion != AppVersion.shared.currentVersion {
                        alert.showNadoAlert(vc: self, message: self.minorUpdateMessage ?? AlertType.softUpdate.alertMessage, confirmBtnTitle: "업데이트", cancelBtnTitle: "다음에 하기")
                    } else {
                        completion()
                    }
                } else {
                    completion()
                }
            }
        }
    }
    
    /// 권한에 따른 제한 알럿 띄워주는 함수
    func showRestrictionAlert(permissionStatus: PermissionType) {
        var permissionMsg = AlertType.noPermission.alertMessage
        var comfirmTitle = "후기 작성"
        var cancelTitle = "다음에 작성"
        
        guard let restrictionAlert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        
        switch permissionStatus {
        case .review:
            restrictionAlert.confirmBtn.press { [weak self] in
                self?.makeAnalyticsEvent(eventName: .write_request_alert, parameterValue: "write_now")
                self?.navigator?.instantiateVC(destinationViewControllerType: ReviewWriteVC.self, useStoryboard: true, storyboardName: "ReviewWriteSB", naviType: .present, modalPresentationStyle: .fullScreen) { reviewWriteVC in }
            }
            
            restrictionAlert.cancelBtn.press { [weak self] in
                self?.makeAnalyticsEvent(eventName: .write_request_alert, parameterValue: "write_later")
            }
        case .inappropriate:
            permissionMsg = AlertType.inappropriateReview.alertMessage
            restrictionAlert.confirmBtn.press {
                self.navigator?.instantiateVC(destinationViewControllerType: ReviewWriteVC.self, useStoryboard: true, storyboardName: "ReviewWriteSB", naviType: .present, modalPresentationStyle: .fullScreen) { reviewWriteVC in }
            }
        case .report:
            permissionMsg = UserPermissionInfo.shared.permissionMsg
            comfirmTitle = "문의하기"
            cancelTitle = "닫기"
            restrictionAlert.confirmBtn.press {
                self.getAppLink { appLink in
                    if let url = URL(string: appLink.kakaoTalkChannel) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        case .firstInappropriate:
            permissionMsg = AlertType.inappropriateReview.alertMessage
            comfirmTitle = "문의하기"
            cancelTitle = "닫기"
            restrictionAlert.confirmBtn.press {
                self.getAppLink { appLink in
                    if let url = URL(string: appLink.kakaoTalkChannel) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        }
        
        restrictionAlert.showNadoAlert(vc: self, message: permissionMsg, confirmBtnTitle: comfirmTitle, cancelBtnTitle: cancelTitle)
    }
    
    /// 신고, 부적절 후기 사용, 후기 미등록자, 일반유저 권한 최종 분기처리 메서드
    func divideUserPermission(isExceptionOfNoReview: Bool = false, defaultAction: () -> Void) {
        if UserPermissionInfo.shared.isUserReported {
            self.showRestrictionAlert(permissionStatus: .report)
        } else if UserPermissionInfo.shared.isReviewInappropriate {
            self.showRestrictionAlert(permissionStatus: .inappropriate)
        } else if !(UserPermissionInfo.shared.isReviewed) {
            isExceptionOfNoReview ? defaultAction() : self.showRestrictionAlert(permissionStatus: .review)
        } else {
            // 아무런 제한이 없을 때 실행되는 action
            defaultAction()
        }
    }
    
    /// 로그인 시 부적절 후기 작성자 권한 처리를 위한 메서드
    func checkIsFirstInappropriate(defaultAction: () -> Void) {
        if UserPermissionInfo.shared.isReviewInappropriate {
            self.showRestrictionAlert(permissionStatus: .firstInappropriate)
            UserPermissionInfo.shared.isReviewInappropriate = false
        } else {
            // 아무런 제한이 없을 때 실행되는 action
            defaultAction()
        }
    }
    
    /// Firebase Analytics 사용자 지정 이벤트를 발생시키는 메서드 (기본 정보만 넘기는 이벤트)
    func makeDefaultAnalyticsEvent(eventName: String) {
        if env() == .production {
            FirebaseAnalytics.Analytics.logEvent(eventName, parameters: [
                "UserID": UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID),
                "FirstMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? "",
                "SecondMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) ?? "",
                "SelectedMajor": (MajorInfo.shared.selectedMajorName != nil) ? MajorInfo.shared.selectedMajorName ?? "" : UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? ""
            ])
        }
    }
    
    /// Firebase Analytics 유저 포스팅 이벤트를 발생시키는 메서드 (기본 정보만 넘기는 이벤트)
    func makePostAnalyticsEvent(postType: String, postedMajor: String) {
        if env() == .production {
            FirebaseAnalytics.Analytics.logEvent("user_post", parameters: [
                "post_type": postType,
                "UserID": UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID),
                "FirstMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? "",
                "SecondMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) ?? "",
                "reviewedMajor": postedMajor
            ])
        }
    }
    
    /// Firebase Analytics 기본 이벤트 메서드
    func makeAnalyticsEvent(eventName: GAEventNameType, parameterValue: String) {
        if env() == .production {
            let parameterName = eventName.hasParameter ? eventName.parameterName : nil
            
            if let parameterName = parameterName {
                FirebaseAnalytics.Analytics.logEvent("\(eventName)", parameters: [parameterName : parameterValue])
            } else {
                FirebaseAnalytics.Analytics.logEvent("\(eventName)", parameters: nil)
            }
        }
    }
    
    /// Firebase Analytics 화면 조회 이벤트를 발생시키는 메서드
    func makeScreenAnalyticsEvent(screenName: String, screenClass: String) {
        if env() == .production {
            FirebaseAnalytics.Analytics.logEvent("screen_view", parameters: [
                AnalyticsParameterScreenName: screenName,
                AnalyticsParameterScreenClass: screenClass,
                "UserID": UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID),
                "FirstMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? "",
                "SecondMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) ?? "",
                "SelectedMajor": (MajorInfo.shared.selectedMajorName != nil) ? MajorInfo.shared.selectedMajorName ?? "" : UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? ""
            ])
        }
    }
    
    
    /// sceneDelegate의 window의 rootViewController를 SignInVC로 설정하는 메서드
    func setWindowRootVC() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.window?.rootViewController = self
    }
}

// MARK: - Custom Methods(화면전환)
extension BaseVC {
    
    /// 특정 탭의 루트 뷰컨으로 이동시키는 메서드
    func goToRootOfTab(index: Int) {
        tabBarController?.selectedIndex = index
        if let nav = tabBarController?.viewControllers?[index] as? UINavigationController {
            nav.popToRootViewController(animated: true)
        }
    }
    
    /// SafariViewController를 불러와 present 화면전환을 하는 메서드 (인앱)
    func presentToSafariVC(url: URL) {
        let safariView: SFSafariViewController = SFSafariViewController(url: url)
        self.present(safariView, animated: true, completion: nil)
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
                self.makeAlert(title: AlertType.networkError.alertMessage)
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
    
    /// access token 갱신
    func updateAccessToken(completion: @escaping (Bool) -> (Void)) {
        SignAPI.shared.updateToken(refreshToken: UserToken.shared.refreshToken ?? "") { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? SignInDataModel {
                    self.setUserToken(accessToken: data.accesstoken, refreshToken: data.refreshtoken)
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
                    AppVersion.shared.latestVersion = response.iOS
                    completion(response)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getLatestVersion { response in
                            completion(response)
                        }
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
    
    /// 신고 API 요청 메서드
    func requestReport(reportedTargetID: Int, postType: ReportPostType, reason: String) {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.requestReport(reportedTargetID: reportedTargetID, postType: postType, reason: reason) { networkResult in
            switch networkResult {
            case .success(_):
                self.makeAlert(title: "신고되었습니다.")
                self.activityIndicator.stopAnimating()
            case .requestErr(let res):
                if let message = res as? String {
                    if message == AlertType.alreadyReported.alertMessage {
                        self.makeAlert(title: AlertType.alreadyReported.alertMessage)
                    } else {
                        self.makeAlert(title: AlertType.networkError.alertMessage)
                    }
                } else if res is Bool {
                    self.updateAccessToken { [weak self] _ in
                        self?.requestReport(reportedTargetID: reportedTargetID, postType: postType, reason: reason)
                    }
                }
                self.activityIndicator.stopAnimating()
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
}
