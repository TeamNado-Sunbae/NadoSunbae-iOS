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
    let menuList = ["프로필 수정", "비밀번호 변경", "알림 설정", "앱정보", "차단 사용자 목록"]
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Custom Methods
    private func pushVC(vc: BaseVC) {
        guard let pushedVC = UIStoryboard.init(name: vc.className, bundle: nil).instantiateViewController(withIdentifier: vc.className) as? BaseVC else { return }
        self.navigationController?.pushViewController(pushedVC, animated: true)
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
        // TODO: 나머지 case들 뷰 구현되는 대로 추가
        case 0:
            let editProfileVC = EditProfileVC()
            pushVC(vc: editProfileVC)
        case 1:
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        default:
            print("SettingVC TableView err")
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
