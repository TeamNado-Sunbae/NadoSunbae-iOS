//
//  BaseVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit
import FirebaseAnalytics

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
    
    /// 토큰 갱신, 자동로그인 시 UserDefaults, Singleton에 값 저장하는 메서드
    func setUpUserdefaultValues(data: SignInDataModel) {
        UserDefaults.standard.set(data.accesstoken, forKey: UserDefaults.Keys.AccessToken)
        UserDefaults.standard.set(data.refreshtoken, forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(data.user.firstMajorID, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set(data.user.firstMajorName, forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(data.user.secondMajorID, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set(data.user.secondMajorName, forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(data.user.userID, forKey: UserDefaults.Keys.UserID)
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
    func getLatestVersion() {
        getLatestVersion { response in
            if AppVersion.shared.latestVersion != AppVersion.shared.currentVersion {
                guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
                alert.confirmBtn.press {
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/1605763068"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
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
    func showRestrictionAlert(permissionStatus: PermissionType) {
        var permissionMsg = "내 학과 후기를 작성해야\n이용할 수 있는 기능이에요."
        var comfirmTitle = "후기 작성"
        var cancelTitle = "다음에 작성"
        
        guard let restrictionAlert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        
        switch permissionStatus {
        case .review:
            restrictionAlert.confirmBtn.press {
                self.presentToReviewWriteVC { _ in }
            }
        case .inappropriate:
            permissionMsg = "부적절한 후기 작성이 확인되어\n열람 권한이 제한되었습니다.\n권한을 얻고 싶다면\n다시 학과후기를 작성해주세요."
            restrictionAlert.confirmBtn.press {
                self.presentToReviewWriteVC { _ in }
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
            permissionMsg = "부적절한 후기 작성이 확인되어\n열람 권한이 제한되었습니다.\n권한을 얻고 싶다면\n다시 학과후기를 작성해주세요."
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
    func divideUserPermission(defaultAction: () -> Void) {
        if UserPermissionInfo.shared.isUserReported {
            self.showRestrictionAlert(permissionStatus: .report)
        } else if UserPermissionInfo.shared.isReviewInappropriate {
            self.showRestrictionAlert(permissionStatus: .inappropriate)
        } else if !(UserPermissionInfo.shared.isReviewed) {
            self.showRestrictionAlert(permissionStatus: .review)
        } else {
            // 아무런 제한이 없을 때 실행되는 action
            defaultAction()
        }
    }
    
    /// Firebase Analytics 사용자 지정 이벤트를 발생시키는 메서드 (기본 정보만 넘기는 이벤트)
    func makeDefaultAnalyticsEvent(eventName: String) {
        FirebaseAnalytics.Analytics.logEvent(eventName, parameters: [
            "UserID": UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID),
            "FirstMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? "",
            "SecondMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) ?? "",
            "SelectedMajor": (MajorInfo.shared.selectedMajorName != nil) ? MajorInfo.shared.selectedMajorName ?? "" : UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? ""
        ])
    }
    
    /// Firebase Analytics 유저 포스팅 이벤트를 발생시키는 메서드 (기본 정보만 넘기는 이벤트)
    func makePostAnalyticsEvent(postType: String, postedMajor: String) {
        FirebaseAnalytics.Analytics.logEvent("user_post", parameters: [
            "post_type": postType,
            "UserID": UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID),
            "FirstMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? "",
            "SecondMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) ?? "",
            "reviewedMajor": postedMajor
        ])
    }
    
    /// Firebase Analytics 화면 조회 이벤트를 발생시키는 메서드
    func makeScreenAnalyticsEvent(screenName: String, screenClass: String) {
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

// MARK: - Custom Methods(화면전환)
extension BaseVC {
    
    /// 특정 탭의 루트 뷰컨으로 이동시키는 메서드
    func goToRootOfTab(index: Int) {
        tabBarController?.selectedIndex = index
        if let nav = tabBarController?.viewControllers?[index] as? UINavigationController {
            nav.popToRootViewController(animated: true)
        }
    }
    
    /// 회원가입VC로 present 화면전환을 하는 메서드
    func presentToSignUpVC() {
        guard let signUpVC = UIStoryboard.init(name: AgreeTermsVC.className, bundle: nil).instantiateViewController(withIdentifier: "SignUpNVC") as? UINavigationController else { return }
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    /// 로그인VC로 present 화면전환을 하는 메서드
    func presentToSignInVC() {
        guard let signInVC = UIStoryboard.init(name: "SignInSB", bundle: nil).instantiateViewController(withIdentifier: SignInVC.className) as? SignInVC else { return }
        signInVC.modalPresentationStyle = .fullScreen
        self.present(signInVC, animated: true, completion: nil)
    }
    
    /// 후기작성VC로 present 화면전환을 하는 메서드
    func presentToReviewWriteVC(completion: @escaping (ReviewWriteVC) -> ()) {
        guard let reviewWriteVC = UIStoryboard.init(name: "ReviewWriteSB", bundle: nil).instantiateViewController(withIdentifier: ReviewWriteVC.className) as? ReviewWriteVC else { return }
        reviewWriteVC.modalPresentationStyle = .fullScreen
        self.present(reviewWriteVC, animated: true, completion: nil)
        completion(reviewWriteVC)
    }
    
    /// 후기상세VC로 navigation push 화면전환을 하는 메서드
    func pushToReviewDetailVC(completion: @escaping (ReviewDetailVC) -> ()) {
        guard let reviewDetailVC = UIStoryboard.init(name: "ReviewDetailSB", bundle: nil).instantiateViewController(withIdentifier: ReviewDetailVC.className) as? ReviewDetailVC else { return }
        completion(reviewDetailVC)
        self.navigationController?.pushViewController(reviewDetailVC, animated: true)
    }
    
    /// 질문작성VC로 present 화면전환을 하는 메서드
    func presentToWriteQuestionVC(completion: @escaping (WriteQuestionVC) -> ()) {
        guard let writeQuestionVC = UIStoryboard(name: Identifiers.WriteQusetionSB, bundle: nil).instantiateViewController(identifier: WriteQuestionVC.className) as? WriteQuestionVC else { return }
        completion(writeQuestionVC)
        writeQuestionVC.modalPresentationStyle = .fullScreen
        self.present(writeQuestionVC, animated: true, completion: nil)
    }
    
    /// 선배마이페이지VC로 navigation push 화면전환을 하는 메서드
    func pushToMypageUserVC(completion: @escaping (MypageUserVC) -> ()) {
        guard let mypageUserVC = UIStoryboard.init(name: MypageUserVC.className, bundle: nil).instantiateViewController(withIdentifier: MypageUserVC.className) as? MypageUserVC else { return }
        completion(mypageUserVC)
        self.navigationController?.pushViewController(mypageUserVC, animated: true)
    }
    
    /// 정보상세VC로 navigation push 화면전환을 하는 메서드
    func pushToInfoDetailVC(completion: @escaping (InfoDetailVC) -> ()) {
        guard let infoDetailVC = UIStoryboard(name: Identifiers.InfoSB, bundle: nil).instantiateViewController(identifier: InfoDetailVC.className) as? InfoDetailVC else { return }
        infoDetailVC.hidesBottomBarWhenPushed = true
        completion(infoDetailVC)
        self.navigationController?.pushViewController(infoDetailVC, animated: true)
    }
    
    /// 질문상세VC로 navigation push 화면전환을 하는 메서드
    func pushToQuestionDetailVC(completion: @escaping (DefaultQuestionChatVC) -> ()) {
        guard let questionDetailVC = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil).instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
        questionDetailVC.hidesBottomBarWhenPushed = true
        completion(questionDetailVC)
        self.navigationController?.pushViewController(questionDetailVC, animated: true)
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
    
    /// 신고 API 요청 메서드
    func requestReport(reportedTargetID: Int, reportedTargetTypeID: Int, reason: String) {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.requestReport(reportedTargetID: reportedTargetID, reportedTargetTypeID: reportedTargetTypeID, reason: reason) { networkResult in
            switch networkResult {
            case .success(_):
                self.makeAlert(title: "신고되었습니다.")
                self.activityIndicator.stopAnimating()
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    }
                } else if res is Int {
                    self.makeAlert(title: "이미 신고한 글/댓글입니다.")
                }
                self.activityIndicator.stopAnimating()
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
