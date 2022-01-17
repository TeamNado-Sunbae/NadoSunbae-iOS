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
    var notificationList = [
        NotificationModel(senderNickName: "최숙주", notiType: .mypageQuestion, time: "1시간 전", isRead: false, title: "확인해", content: "알림읽어용~!!&^^"),
        NotificationModel(senderNickName: "정정숙", notiType: .answerQuestion, time: "1시간 전", isRead: true, title: "확인해", content: "알림읽어용~!!&^^"),
        NotificationModel(senderNickName: "황정숙", notiType: .notiInfo, time: "1시간 전", isRead: false, title: "확인해", content: "알림읽어용~!!&^^"),
        NotificationModel(senderNickName: "김두숙", notiType: .writtenInfo, time: "1시간 전", isRead: false, title: "확인해", content: "알림읽어용~!!&^^"),
        NotificationModel(senderNickName: "김나도", notiType: .notiQuestion, time: "1시간 전", isRead: true, title: "확인해", content: "알림읽어용~!!&^^"),
        NotificationModel(senderNickName: "이선배", notiType: .answerInfo, time: "1시간 전", isRead: true, title: "확인해", content: "알림읽어용~!!&^^"),
        NotificationModel(senderNickName: "김나도", notiType: .answerQuestion, time: "1시간 전", isRead: false, title: "확인해", content: "알림읽어용~!!&^^")
    ]
    
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
