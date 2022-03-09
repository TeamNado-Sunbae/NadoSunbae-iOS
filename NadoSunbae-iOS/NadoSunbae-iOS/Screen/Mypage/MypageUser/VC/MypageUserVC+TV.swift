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
        
        /// 후기글 작성하지 않은 유저라면 후기글 열람 제한
        if !(UserDefaults.standard.bool(forKey: UserDefaults.Keys.IsReviewed)) {
            guard let restrictionAlert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            
            /// 후기 작성 버튼 클릭시 후기 작성 페이지로 이동
            restrictionAlert.confirmBtn.press {
                let ReviewWriteSB = UIStoryboard.init(name: "ReviewWriteSB", bundle: nil)
                guard let nextVC = ReviewWriteSB.instantiateViewController(withIdentifier: ReviewWriteVC.className) as? ReviewWriteVC else { return }
                
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil)
            }
            restrictionAlert.showNadoAlert(vc: self, message: "내 학과 후기를 작성해야\n이용할 수 있는 기능이에요.", confirmBtnTitle: "후기 작성", cancelBtnTitle: "다음에 작성")
        } else {
            let chatSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil)
            guard let personalChatVC = chatSB.instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
            
            personalChatVC.questionType = .personal
            personalChatVC.naviStyle = .push
            personalChatVC.postID = self.questionList[indexPath.row].postID
            personalChatVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(personalChatVC, animated: true)
        }
    }
}
