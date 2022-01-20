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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseQuestionTVC.className, for: indexPath) as? BaseQuestionTVC else { return UITableViewCell() }
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
        let groupChatSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil)
        guard let groupChatVC = groupChatSB.instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
        
        // TODO: 추후에 Usertype, isWriter 정보도 함께 넘길 예정(?)
        groupChatVC.questionType = .personal
        groupChatVC.naviStyle = .push
        
        self.navigationController?.pushViewController(groupChatVC, animated: true)
    }
}
