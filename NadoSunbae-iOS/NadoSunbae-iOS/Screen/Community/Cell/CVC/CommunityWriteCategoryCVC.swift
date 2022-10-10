//
//  CommunityWriteCategoryCVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/25.
//

import UIKit
import SnapKit
import Then

class CommunityWriteCategoryCVC: CodeBaseCVC {
    
    // MARK: Components
    private let radioBtn = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setImage(UIImage(named: "RadioButton"), for: .normal)
        $0.contentMode = .scaleToFill
    }
    
    private let categoryLabel = UILabel().then {
        $0.font = .PretendardR(size: 14.0)
        $0.textColor = .gray3
    }
    
    override var isSelected: Bool {
        didSet {
            categoryLabel.textColor = isSelected ? .nadoBlack : .gray3
            radioBtn.setImage(isSelected ? UIImage(named: "RadioButtonMint") : UIImage(named: "RadioButton"), for: .normal)
        }
    }
    
    override func setupViews() {
        configureUI()
    }
}

// MARK: - UI
extension CommunityWriteCategoryCVC {
    private func configureUI() {
        addSubviews([radioBtn, categoryLabel])
        
        radioBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(radioBtn.snp.trailing).offset(5)
            $0.centerY.equalTo(radioBtn)
        }
    }
}

// MARK: - Custom Methods
extension CommunityWriteCategoryCVC {
    func setData(categoryText: String) {
        categoryLabel.text = categoryText
    }
    
    func setSelectedRadioBtnImage(isEdit: Bool) {
        radioBtn.isSelected = true
        radioBtn.setImage(UIImage(named: isEdit ? "RadioButtonDark" : "RadioButtonMint"), for: .selected)
    }
}
