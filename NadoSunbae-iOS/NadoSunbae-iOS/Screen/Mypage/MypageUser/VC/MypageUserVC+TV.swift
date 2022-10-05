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
        let questionData = self.questionList[indexPath.row]
        cell.setPostData(data: PostListResModel(postID: questionData.postID, type: nil, title: questionData.title, content: questionData.content, createdAt: questionData.createdAt, majorName: "", writer: questionData.writer, isAuthorized: false, commentCount: questionData.commentCount, like: questionData.like))
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
        
        /// 유저의 권한 분기처리
        self.divideUserPermission() {
            self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                questionDetailVC.hidesBottomBarWhenPushed = true
                questionDetailVC.naviStyle = .push
                questionDetailVC.postID = self.questionList[indexPath.row].postID
            }
        }
    }
}
