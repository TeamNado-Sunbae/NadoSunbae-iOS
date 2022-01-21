//
//  InfoListTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/21.
//

import UIKit

class InfoListTVC: BaseQuestionTVC {

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7))
    }
}
