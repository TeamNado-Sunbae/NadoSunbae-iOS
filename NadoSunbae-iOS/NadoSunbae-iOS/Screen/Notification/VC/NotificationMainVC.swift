//
//  NotificationMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class NotificationMainVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var notificationTV: UITableView!
    
    // MARK: Properties
    var notificationList = [NotificationModel]()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpTV()
    }
}

// MARK: - UI
extension NotificationMainVC {
    private func configureUI() {
        notificationTV.backgroundColor = .clear
        notificationTV.separatorStyle = .none
    }
    
    private func setUpTV() {
        notificationTV.delegate = self
        notificationTV.dataSource = self
    }
}

// MARK: - Custom Methods
extension NotificationMainVC {
    
}
