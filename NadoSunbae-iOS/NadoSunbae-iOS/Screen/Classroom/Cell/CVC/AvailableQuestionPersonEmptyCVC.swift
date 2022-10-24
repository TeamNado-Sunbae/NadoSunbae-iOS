//
//  AvailableQuestionPersonEmptyCVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/24.
//

import UIKit
import Then
import SnapKit

final class AvailableQuestionPersonEmptyCVC: CodeBaseCVC {
    // MARK: Property
    private let emptyLabel = UILabel().then {
        $0.text = "등록된 선배가 없습니다."
        $0.textColor = .gray2
        $0.font = .PretendardR(size: 14.0)
    }
    
    override func setupViews() {
        configureUI()
    }
}

// MARK: - UI
extension AvailableQuestionPersonEmptyCVC {
    private func configureUI() {
        self.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
