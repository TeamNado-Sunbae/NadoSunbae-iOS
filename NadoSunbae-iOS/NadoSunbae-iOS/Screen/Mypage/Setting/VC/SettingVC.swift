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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXIB()
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
        
        alert.showNadoAlert(vc: self, message: "로그아웃할래?(미정)", confirmBtnTitle: "네", cancelBtnTitle: "아니요")
    }
    
    @IBAction func tapWithDrawBtn(_ sender: Any) {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        
        alert.cancelBtn.press {
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.confirmBtn.press {
            self.requestWithDraw()
        }
        
        alert.showNadoAlert(vc: self, message: "탈퇴할래?(미정)", confirmBtnTitle: "네", cancelBtnTitle: "아니요")
    }
    
    @IBAction func tapServiceContactBtn(_ sender: Any) {
        if let url = URL(string: "http://pf.kakao.com/_pxcFib") {
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
        
    }
    
    private func requestWithDraw() {
        
    }
}
