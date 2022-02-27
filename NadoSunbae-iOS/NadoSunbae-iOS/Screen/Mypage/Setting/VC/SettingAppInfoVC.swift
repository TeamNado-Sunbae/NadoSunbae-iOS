//
//  SettingAppInfoVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class SettingAppInfoVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.configureTitleLabel(title: "앱정보")
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var appInfoTV: UITableView! {
        didSet {
            appInfoTV.dataSource = self
            appInfoTV.delegate = self
            appInfoTV.isScrollEnabled = false
            appInfoTV.rowHeight = 63.adjustedH
        }
    }
    @IBOutlet weak var appInfoTVHeight: NSLayoutConstraint! {
        didSet {
            appInfoTVHeight.constant = 256.adjustedH
        }
    }
    
    // MARK: Properties
    let menuList = ["서비스 이용규칙", "서비스 이용약관", "오픈소스 라이선스", "버전 정보"]
    var latestVersion = ""
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXIB()
    }
    
    
    // MARK: Custom Methods
    private func registerXIB() {
        SettingTVC.register(target: appInfoTV)
        SettingVersionTVC.register(target: appInfoTV)
    }
}

// MARK: - UITableViewDataSource
extension SettingAppInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingVersionTVC.className, for: indexPath) as? SettingVersionTVC else { return UITableViewCell() }
            cell.setData(title: menuList[indexPath.row], version: latestVersion)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTVC.className, for: indexPath) as? SettingTVC else { return UITableViewCell() }
            cell.setTitle(title: menuList[indexPath.row])
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingAppInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        // TODO: 나머지 case들 뷰 구현되는 대로 추가
            
        /// 서비스 이용규칙
        case 0:
            break
            
        /// 서비스 이용약관
        case 1:
            break
            
        /// 오픈소스 라이선스
        case 2:
            break
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    }
}
