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
    override func configureUI() {
        super.configureUI()
        contentView.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        questionTitleLabel.snp.removeConstraints()
        questionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(categoryLabel)
        }
        
        nicknameLabel.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-23)
        }
    }
}

// MARK: - Custom Methods
extension CommunityTVC {
    func setCommunityData(data: PostListResModel) {
        categoryLabel.text = data.type
        questionTitleLabel.text = data.title
        questionContentLabel.text = data.content
        nicknameLabel.text = data.writer.nickname
        questionTimeLabel.text = data.createdAt.serverTimeToString(forUse: .forDefault)
        commentCountLabel.text = "\(data.commentCount)"
        likeCountLabel.text = "\(data.like.likeCount)"
        likeImgView.image = data.like.isLiked ? UIImage(named: "heart_filled") : UIImage(named: "btn_heart")
    }
}
