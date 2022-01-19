//
//  MypageMainVC+TV.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/16.
//

import UIKit

// MARK: - UITableDataSource
extension MypageMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageQuestionTVC.className, for: indexPath) as? MypageQuestionTVC else { return UITableViewCell() }
        cell.setData(data: self.questionList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MypageMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
