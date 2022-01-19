//
//  NotificationMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class NotificationMainVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: UIView! {
        didSet {
            navView.addShadow(offset: CGSize(width: 0, height: 4), color: .shadowDefault, opacity: 1, radius: 16)
        }
    }
    
    @IBOutlet weak var noNotiLabel: UILabel! {
        didSet {
            noNotiLabel.isHidden = true
        }
    }
    @IBOutlet weak var notificationTV: UITableView! {
        didSet {
            notificationTV.delegate = self
            notificationTV.dataSource = self
            notificationTV.backgroundColor = .clear
            notificationTV.separatorStyle = .none
            notificationTV.rowHeight = UITableView.automaticDimension
            notificationTV.sectionHeaderHeight = 8
            notificationTV.sectionFooterHeight = 8
            notificationTV.headerView(forSection: 0)?.backgroundColor = .clear
            notificationTV.tableFooterView?.backgroundColor = .clear
        }
    }
    
    // MARK: Properties
    var notificationList = [NotificationList]()
    
    /// TableView 투명한 header, footer를 위한 empty View
    var emptyViewForTV = UIView()
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeVisibleTabBar()
        getNotiList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI
extension NotificationMainVC {
    private func configureUI() {
        emptyViewForTV.backgroundColor = .clear
    }
    
    private func setEmptyState() {
        noNotiLabel.isHidden = notificationList.isEmpty ? false : true
    }
    
    private func makeVisibleTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Network
extension NotificationMainVC {
    private func getNotiList() {
        self.activityIndicator.startAnimating()
        NotificationAPI.shared.getNotiList { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? NotificationDataModel {
                    self.notificationList = data.notificationList
                    DispatchQueue.main.async {
                        self.notificationTV.reloadData()
                        self.setEmptyState()
                    }
                    self.activityIndicator.stopAnimating()
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
    
    func readNoti(notiID: Int) {
        NotificationAPI.shared.readNoti(notiID: notiID) { networkResult in
            switch networkResult {
            case .success(let res):
                if res is ReadNotificationDataModel {
                    self.getNotiList()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print("request err: ", message)
                }
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    func deleteNoti(notiID: Int) {
        NotificationAPI.shared.deleteNoti(notiID: notiID) { networkResult in
            switch networkResult {
            case .success(let res):
                if res is DeleteNotificationDataModel {
                    self.getNotiList()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print("request err: ", message)
                }
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
