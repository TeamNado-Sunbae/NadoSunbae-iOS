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
        divideUserPermission() {
            switch notificationList[indexPath.section].notificationTypeID {
                
                /// 내가 선배일 때, 1:1 질문글로 이동
            case 1, 4, 6:
                self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                    questionDetailVC.hidesBottomBarWhenPushed = true
                    questionDetailVC.naviStyle = .push
                    questionDetailVC.postID = self.notificationList[indexPath.section].postID
                    questionDetailVC.isAuthorized = true
                }
                
                /// 내가 후배일 때, 1:1 질문글로 이동
            case 2, 7:
                self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                    questionDetailVC.hidesBottomBarWhenPushed = true
                    questionDetailVC.naviStyle = .push
                    questionDetailVC.postID = self.notificationList[indexPath.section].postID
                    questionDetailVC.isAuthorized = true
                }
                
                /// 커뮤니티로 이동
            case 3, 5, 8, 9:
                self.navigator?.instantiateVC(destinationViewControllerType: CommunityPostDetailVC.self, useStoryboard: true, storyboardName: "CommunityPostDetailSB", naviType: .push) { postDetailVC in
                    postDetailVC.postID = self.notificationList[indexPath.section].postID
                    postDetailVC.hidesBottomBarWhenPushed = true
                }
                
                /// 커뮤니티_특정학과대상 질문글 푸시알림인 경우 GA Event 수집 및 커뮤니티로 이동
            case 10:
                self.makeAnalyticsEvent(eventName: .mention_function, parameterValue: "mention_active")
                self.navigator?.instantiateVC(destinationViewControllerType: CommunityPostDetailVC.self, useStoryboard: true, storyboardName: "CommunityPostDetailSB", naviType: .push) { postDetailVC in
                    postDetailVC.postID = self.notificationList[indexPath.section].postID
                    postDetailVC.hidesBottomBarWhenPushed = true
                }
            default:
                debugPrint("notification type error")
            }
            readNoti(notiID: notificationList[indexPath.section].notificationID)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
