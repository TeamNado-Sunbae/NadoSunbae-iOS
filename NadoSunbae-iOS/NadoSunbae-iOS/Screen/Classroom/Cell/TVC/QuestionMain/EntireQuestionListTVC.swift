//
//  EntireQuestionListTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import UIKit

class EntireQuestionListTVC: BaseQuestionTVC {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 12, bottom: 11, right: 10))
    }
}
