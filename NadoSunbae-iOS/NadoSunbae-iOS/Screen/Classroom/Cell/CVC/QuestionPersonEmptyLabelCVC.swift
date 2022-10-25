//
//  QuestionPersonEmptyLabelCVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/24.
//

import UIKit

final class QuestionPersonEmptyLabelCVC: AvailableQuestionPersonEmptyCVC {
    override func configureUI() {
        self.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
