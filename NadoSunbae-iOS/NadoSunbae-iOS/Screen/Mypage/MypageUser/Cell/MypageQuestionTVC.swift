//
//  MypageQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/15.
//

import UIKit
import SnapKit
import Then

class MypageQuestionTVC: BaseQuestionTVC {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override func configureUI() {
        super.configureUI()
        
        /// UI에 문제가 됐던 프로퍼티들의 Constraints를 업데이트.....
        questionTitleLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(12)
        }
        
        questionContentLabel.snp.updateConstraints {
            $0.top.equalTo(questionTitleLabel.snp.bottom).offset(4)
        }
        
        nicknameLabel.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-18)
        }
    }
}
