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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLatestVersion()
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

// MARK: - Network
extension SettingAppInfoVC {
    private func getLatestVersion() {
        MypageSettingAPI.shared.getLatestVersion { networkResult in
            switch networkResult {
            case .success(let res):
                if let response = res as? GetLatestVersionResponseModel {
                    self.latestVersion = response.iOS
                    self.appInfoTV.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
                }
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
}
