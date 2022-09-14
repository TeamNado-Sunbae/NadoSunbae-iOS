//
//  QuestionToPersonHeaderTVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/13.
//

import UIKit
import Then
import SnapKit

final class QuestionToPersonHeaderTVC: CodeBaseTVC {
    
    // MARK: Properties
    private let headerLabel = UILabel().then {
        $0.font = .PretendardSB(size: 14.0)
        $0.textColor = .gray4
    }
    
    private let seeMoreBtn = UIButton().then {
        $0.setImage(UIImage(named: "comp_more"), for: .normal)
    }
    
    override func setViews() {
        configureUI()
    }
}

// MARK: - UI
extension QuestionToPersonHeaderTVC {
    private func configureUI() {
        contentView.addSubviews([headerLabel, seeMoreBtn])
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        seeMoreBtn.snp.makeConstraints {
            $0.top.equalTo(headerLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(61)
            $0.height.equalTo(24)
        }
        
        backgroundColor = .paleGray
    }
    
    func hideSeeMoreBtn() {
        seeMoreBtn.isHidden = true
    }
    
    func setHeaderLabelText(headerText: String) {
        headerLabel.text = headerText
    }
}
