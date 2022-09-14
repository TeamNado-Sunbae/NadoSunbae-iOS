//
//  SeeMoreQuestionPersonCVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/13.
//

import UIKit
import SnapKit
import Then

final class SeeMoreQuestionPersonCVC: CodeBaseCVC {
    
    private let seeMoreImgView = UIImageView().then {
        $0.image = UIImage(named: "seeMoreMint")
    }
    
    private let seeMoreLabel = UILabel().then {
        $0.text =  "더보기"
        $0.textColor = .mainDefault
        $0.font = .PretendardM(size: 14.0)
    }
    
    private let seeMoreStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }
    
    override func setupViews() {
        configureUI()
        setUpUI()
    }
}

// MARK: - UI
extension SeeMoreQuestionPersonCVC {
    
    /// UI구성 메서드
    private func configureUI() {
        contentView.addSubview(seeMoreStackView)
        
        seeMoreStackView.addArrangedSubview(seeMoreImgView)
        seeMoreStackView.addArrangedSubview(seeMoreLabel)
        
        seeMoreImgView.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(16)
        }
        
        seeMoreStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setUpUI() {
        contentView.layer.cornerRadius = 22
        contentView.backgroundColor = .gray0
    }
}

