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
    }
    @IBOutlet weak var settingTV: UITableView! {
        didSet {
            settingTV.dataSource = self
            settingTV.delegate = self
        }
    }
    
    // MARK: Properties
    let menuList = ["프로필 수정", "비밀번호 변경", "알림 설정", "앱정보", "차단 사용자 목록"]
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            guard let editProfileVC = UIStoryboard.init(name: EditProfileVC.className, bundle: nil).instantiateViewController(withIdentifier: EditProfileVC.className) as? EditProfileVC else { return }
//            self.navigationController?.pushViewController(editProfileVC, animated: true)
//        case 1:
//        case 2:
//        case 3:
//        case 4:
//        default:
//            print("SettingVC TableView err")
//            break
//        }
//    }
}
