//
//  QuestionPersonCVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit
import SnapKit
import Then

class QuestionPersonCVC: CodeBaseCVC {
    
    // MARK: Properties
    private (set) lazy var personProfileImageView = NadoMaskedImgView().then {
        $0.maskImg = UIImage(named: "property172")
    }
    
    private (set) lazy var nicknameLabel = UILabel().then {
        $0.textColor = .nadoBlack
        $0.font = .PretendardSB(size: 14.0)
        $0.sizeToFit()
    }
    
    private let majorNameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 4
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
    }
    
    private let majorLabel = UILabel().then {
        $0.textColor = .mainDefault
        $0.font = .PretendardR(size: 12.0)
        $0.sizeToFit()
    }
    
    private let majorStartLabel = UILabel().then {
        $0.textColor = .gray4
        $0.font = .PretendardR(size: 12.0)
        $0.sizeToFit()
    }
    
    override func setupViews() {
        configureUI()
    }
}

// MARK: - UI
extension QuestionPersonCVC {
    
    /// UI구성 메서드
    @objc
    func configureUI() {
        self.addSubviews([personProfileImageView, nicknameLabel, majorNameStackView])
        majorNameStackView.addArrangedSubview(majorLabel)
        majorNameStackView.addArrangedSubview(majorStartLabel)
        
        personProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.height.width.equalTo(72)
            $0.centerX.equalTo(contentView)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(personProfileImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(personProfileImageView)
        }
        
        majorNameStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(personProfileImageView)
        }
    }
}

// MARK: - Custom Methods
extension QuestionPersonCVC {
    func setData(model: QuestionUser) {
        nicknameLabel.text = model.nickname
        personProfileImageView.image = UIImage(named: "grayProfileImage\(model.profileImageID)") ?? nil
        if model.isFirstMajor == true {
            majorLabel.text = "본"
        } else {
            majorLabel.text = "제2"
        }
        majorStartLabel.text = model.majorStart + " " + "진입"
    }
}
