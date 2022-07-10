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
        cell.deleteBtn.tag = indexPath.section
        cell.deleteBtn.addTarget(self, action: #selector(self.removeCell), for: .touchUpInside)
        
        return cell
    }
    
    @objc func removeCell(_ sender: UIButton) {
        self.deleteNoti(notiID: self.notificationList[sender.tag].notificationID)
    }
}

// MARK: - UITableViewDelegate
extension NotificationMainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch notificationList[indexPath.section].notificationTypeID.getNotiType() {
        case .writtenInfo, .answerInfo:
            divideUserPermission() {
                self.navigator?.instantiateVC(destinationViewControllerType: InfoDetailVC.self, useStoryboard: true, storyboardName: Identifiers.InfoSB, naviType: .push) { infoDetailVC in
                    infoDetailVC.hidesBottomBarWhenPushed = true
                    infoDetailVC.postID = self.notificationList[indexPath.section].postID
                    self.readNoti(notiID: self.notificationList[indexPath.section].notificationID)
                }
            }

        case .writtenQuestion, .answerQuestion:
            divideUserPermission() {
                self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                    questionDetailVC.hidesBottomBarWhenPushed = true
                    questionDetailVC.questionType = self.notificationList[indexPath.section].isQuestionToPerson ? .personal : .group
                    questionDetailVC.naviStyle = .push
                    questionDetailVC.postID = self.notificationList[indexPath.section].postID
                    self.readNoti(notiID: self.notificationList[indexPath.section].notificationID)
                }
            }
            
        case .mypageQuestion:
            self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                questionDetailVC.hidesBottomBarWhenPushed = true
                questionDetailVC.questionType = .personal
                questionDetailVC.naviStyle = .push
                questionDetailVC.postID = self.notificationList[indexPath.section].postID
                self.readNoti(notiID: self.notificationList[indexPath.section].notificationID)
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return emptyViewForTV
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return emptyViewForTV
    }
}
