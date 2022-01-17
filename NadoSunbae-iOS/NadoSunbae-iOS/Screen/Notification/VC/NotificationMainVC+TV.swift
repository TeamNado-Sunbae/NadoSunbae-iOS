//
//  NotificationMainVC+TV.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/17.
//

import UIKit

// MARK: - UITableViewDataSource
extension NotificationMainVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTVC.className, for: indexPath) as? NotificationTVC else { return UITableViewCell() }
        cell.setData(data: notificationList[indexPath.section])
        cell.deleteBtn.press {
            // TODO: 서버에 읽음 처리 후 다시 fetch
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return emptyViewForTV
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return emptyViewForTV
    }
}
