//
//  MypageUserVC+TV.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/15.
//

import UIKit

// MARK: - UITableViewDataSource
extension MypageUserVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseQuestionTVC()
        cell.setData(data: questionList[indexPath.row])
        cell.layoutIfNeeded()

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MypageUserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// 후기글 작성하지 않은 유저라면 게시글 열람 제한
        if !(UserPermissionInfo.shared.isReviewed) {
            showRestrictionAlert(permissionStatus: .review)
        } else {
            pushToQuestionDetailVC { defaultQuestionChatVC in
                defaultQuestionChatVC.questionType = .personal
                defaultQuestionChatVC.naviStyle = .push
                defaultQuestionChatVC.postID = self.questionList[indexPath.row].postID
            }
        }
    }
}
