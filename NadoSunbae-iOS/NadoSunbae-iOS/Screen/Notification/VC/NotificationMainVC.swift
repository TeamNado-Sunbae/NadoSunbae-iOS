//
//  NotificationMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class NotificationMainVC: BaseVC {
    
    // MARK: @IBOutlet
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
    var notificationList = [NotificationModel]()
    
    /// TableView 투명한 header, footer를 위한 empty View
    var emptyViewForTV = UIView()
    
    // MARK: LifeCycle
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
}

// MARK: - Custom Methods
extension NotificationMainVC {
    // TODO: 서버 붙이고 어쩌고.. 여기에 함수 넣을 거임!
}
