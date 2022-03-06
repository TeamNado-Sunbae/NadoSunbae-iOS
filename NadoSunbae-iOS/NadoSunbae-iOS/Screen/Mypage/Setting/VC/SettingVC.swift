//
//  SettingVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/27.
//

import UIKit

class SettingVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.configureTitleLabel(title: "내 설정")
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var settingTV: UITableView! {
        didSet {
            settingTV.dataSource = self
            settingTV.delegate = self
            settingTV.isScrollEnabled = false
            settingTV.rowHeight = 63.adjustedH
        }
    }
    @IBOutlet weak var settingTVHeight: NSLayoutConstraint! {
        didSet {
            settingTVHeight.constant = 320.adjustedH
        }
    }
    
    // MARK: Properties
    let menuList = ["프로필 수정", "비밀번호 재설정", "알림 설정", "앱정보", "차단 사용자 목록"]
    var kakaoLink = ""
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXIB()
        getAppLink { appLink in
            self.kakaoLink = appLink.kakaoTalkChannel
        }
    }
    
    // MARK: @IBAction
    @IBAction func tapSignOutBtn(_ sender: Any) {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        
        alert.cancelBtn.press {
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.confirmBtn.press {
            self.requestSignOut()
        }
        
        alert.showNadoAlert(vc: self, message: "로그아웃하시겠습니까?", confirmBtnTitle: "네", cancelBtnTitle: "아니요")
    }
    
    @IBAction func tapWithDrawBtn(_ sender: Any) {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        
        alert.cancelBtn.press {
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.confirmBtn.press {
            self.requestWithDraw(PW: alert.textField.text ?? "")
        }
        
        alert.showNadoAlert(vc: self, message: "탈퇴하시겠습니까?", confirmBtnTitle: "확인", cancelBtnTitle: "취소", type: .withTextField)
    }
    
    @IBAction func tapServiceContactBtn(_ sender: Any) {
        if let url = URL(string: kakaoLink) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: Custom Methods
    private func pushVC(vc: BaseVC) {
        guard let pushedVC = UIStoryboard.init(name: vc.className, bundle: nil).instantiateViewController(withIdentifier: vc.className) as? BaseVC else { return }
        self.navigationController?.pushViewController(pushedVC, animated: true)
    }
    
    private func registerXIB() {
        SettingTVC.register(target: settingTV)
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

// MARK: - UITableViewDataSource
extension SettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTVC.className, for: indexPath) as? SettingTVC else { return UITableViewCell() }
        cell.setTitle(title: menuList[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        /// 프로필 수정
        case 0:
            let editProfileVC = EditProfileVC()
            pushVC(vc: editProfileVC)
            
        /// 비밀번호 재설정
        case 1:
            let resetPWVC = ResetPWVC()
            pushVC(vc: resetPWVC)
            
        /// 알림 설정
        case 2:
            let notificationSettingVC = NotificationSettingVC()
            pushVC(vc: notificationSettingVC)
            
        /// 앱정보
        case 3:
            let settingAppInfoVC = SettingAppInfoVC()
            pushVC(vc: settingAppInfoVC)
            
        /// 차단 사용자 목록
        case 4:
            let blockListVC = BlockListVC()
            pushVC(vc: blockListVC)
        default:
            print("SettingVC TableView err")
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Network
extension SettingVC {
    private func requestSignOut() {
        self.activityIndicator.startAnimating()
        SignAPI.shared.requestSignOut { networkResult in
            switch networkResult {
            case .success:
                self.setRemoveUserdefaultValues()
                guard let signInVC = UIStoryboard.init(name: "SignInSB", bundle: nil).instantiateViewController(withIdentifier: SignInVC.className) as? SignInVC else { return }
                signInVC.modalPresentationStyle = .fullScreen
                self.present(signInVC, animated: true, completion: nil)
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    private func requestWithDraw() {
        
    }
}
