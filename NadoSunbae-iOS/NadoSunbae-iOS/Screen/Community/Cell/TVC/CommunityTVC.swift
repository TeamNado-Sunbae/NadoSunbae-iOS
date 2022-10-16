//
//  CommunityTVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/15.
//

import UIKit
import Then
import SnapKit

class CommunityTVC: BaseQuestionTVC {
    
    // MARK: Properties
    let categoryLabel = UILabel().then {
        $0.textColor = .mainDefault
        $0.font = .PretendardR(size: 12.0)
        $0.sizeToFit()
    }
}

// MARK: - UI
extension CommunityTVC {
    private func configureCommunityUI() {
        contentView.addSubviews([categoryLabel, questionTitleLabel, questionContentLabel, nicknameLabel, questionTimeLabel, commentImgView, commentCountLabel, likeImgView, likeCountLabel])
        
        categoryLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(18)
        }
        
        questionTitleLabel.snp.remakeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(categoryLabel)
            $0.height.equalTo(22)
        }
        
        questionContentLabel.snp.makeConstraints {
            $0.top.equalTo(questionTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.lessThanOrEqualTo(44)
        }
        
        nicknameLabel.snp.remakeConstraints {
            $0.top.equalTo(questionContentLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-23)
        }
        
        questionTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(questionTitleLabel.snp.trailing)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        likeImgView.snp.makeConstraints {
            $0.trailing.equalTo(likeCountLabel.snp.leading)
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(likeImgView.snp.leading).offset(-8)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        commentImgView.snp.makeConstraints {
            $0.trailing.equalTo(commentCountLabel.snp.leading)
            $0.height.width.equalTo(32)
            $0.centerY.equalTo(nicknameLabel)
        }
    }
}

// MARK: - Custom Methods
extension CommunityTVC {
    private func setCommunityData(data: PostListResModel) {
        categoryLabel.text = data.type
        questionTitleLabel.text = data.title
        questionContentLabel.text = data.content
        questionContentLabel.setLineSpacing(lineSpacing: 5.0)
        questionContentLabel.layoutIfNeeded()
        nicknameLabel.text = data.majorName
        questionTimeLabel.text = data.createdAt.serverTimeToString(forUse: .forDefault)
        commentCountLabel.text = "\(data.commentCount)"
        likeCountLabel.text = "\(data.like.likeCount)"
        likeImgView.image = data.like.isLiked ? UIImage(named: "heart_filled") : UIImage(named: "btn_heart")
    }
}

// MARK: - Public Methods
extension CommunityTVC {
    
    /// 커뮤니티 Cell의 필수 구성 요소를 설정하는 메서드
    func setEssentialCommunityCellInfo(data: PostListResModel) {
        setCommunityData(data: data)
        configureCommunityUI()
    }
}
