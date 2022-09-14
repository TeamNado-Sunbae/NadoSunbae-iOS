//
//  AvailableQuestionPersonCVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/14.
//

import UIKit
import SnapKit
import Then

final class AvailableQuestionPersonCVC: QuestionPersonCVC {
    
    override func configureUI() {
        super.configureUI()
        
        nicknameLabel.font = .PretendardSB(size: 13.0)
         
        personProfileImageView.snp.updateConstraints {
            $0.top.equalToSuperview()
            $0.height.width.equalTo(64)
        }
    }
}
