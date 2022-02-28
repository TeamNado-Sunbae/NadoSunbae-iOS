//
//  NotificationSettingVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class NotificationSettingVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.configureTitleLabel(title: "알림 설정")
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var settingTV: UITableView! {
        didSet {
            settingTV.dataSource = self
            settingTV.rowHeight = 64.adjustedH
            settingTV.separatorStyle = .none
            settingTV.allowsSelection = false
        }
    }
    
    // MARK: Properties
    var isSystemNotiSettingOn = false
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXIB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSystemNotiSetting()
    }
    
    // MARK: Custom Methods
    private func registerXIB() {
        NotificationSettingBasicTVC.register(target: settingTV)
    }
    
    /// 나도선배 앱 알림 설정을 시스템에서 받아오는 함수
    private func getSystemNotiSetting() {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            switch setting.alertSetting {
            case .enabled:
                self.isSystemNotiSettingOn = true
            default:
                break
            }
            DispatchQueue.main.async {
                self.settingTV.reloadData()
            }
        }
    }
}

extension NotificationSettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingBasicTVC.className, for: indexPath) as? NotificationSettingBasicTVC else { return UITableViewCell() }
        cell.setData(title: "알림", isOn: isSystemNotiSettingOn)
        return cell
    }
}
