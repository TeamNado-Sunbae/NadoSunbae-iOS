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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 16, bottom: 11, right: 16))
    }
}
