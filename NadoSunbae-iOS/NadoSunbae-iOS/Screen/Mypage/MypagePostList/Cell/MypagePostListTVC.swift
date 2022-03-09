//
//  MypagePostListTVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/18.
//

import UIKit

class MypagePostListTVC: BaseQuestionTVC {
    
    func setMypageMyPostData(data: MypageMyPostModel) {
        self.questionTitleLabel.text = data.title
        questionContentLabel.text = data.content
        nicknameLabel.text = data.majorName
        questionTimeLabel.text = data.createdAt.serverTimeToString(forUse: .forDefault)
        commentCountLabel.text = "\(data.commentCount)"
        likeCountLabel.text = "\(data.like.likeCount)"
        likeImgView.image = data.like.isLiked ? UIImage(named: "heart_filled") : UIImage(named: "btn_heart")
    }
    
    func setMypageMyAnswerData(data: MypageMyAnswerModel) {
        self.questionTitleLabel.text = data.title
        questionContentLabel.text = data.content
        nicknameLabel.text = data.writer.nickname
        questionTimeLabel.text = data.createdAt.serverTimeToString(forUse: .forDefault)
        commentCountLabel.text = "\(data.commentCount)"
        likeCountLabel.text = "\(data.like.likeCount)"
        likeImgView.image = data.like.isLiked ? UIImage(named: "heart_filled") : UIImage(named: "btn_heart")
    }
}
