//
//  QuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit
import SnapKit
import Then

class QuestionTVC: BaseQuestionTVC {
    
    override func configureUI() {
        super.configureUI()
        
        questionTitleLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        questionContentLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(questionTitleLabel.snp.bottom).offset(4)
        }
        
        nicknameLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-18)
        }
    }
}
