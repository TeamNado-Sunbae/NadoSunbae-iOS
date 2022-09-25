//
//  RankingTVC.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/19.
//

import UIKit
import SnapKit
import Then

class RankingTVC: CodeBaseTVC {
    
    // MARK: Properties
    private let medalImgView = UIImageView()
    
    private let rankLabel = UILabel().then {
        $0.font = .PretendardM(size: 16)
        $0.textAlignment = .center
        $0.textColor = .mainDark
    }
    
    private let profileImgView = NadoMaskedImgView().then {
        $0.maskImg = UIImage(named: "property172")
    }
    
    private let responseRateLabel = UILabel().then {
        $0.font = .PretendardM(size: 12)
        $0.textAlignment = .left
        $0.textColor = .mainDefault
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .PretendardM(size: 16)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private let majorLabel = UILabel().then {
        $0.text = "본 |"
        $0.font = .PretendardR(size: 12)
        $0.textAlignment = .left
        $0.textColor = .gray2
    }
    
    private let majorInfoLabel = UILabel().then {
        $0.font = .PretendardR(size: 12)
        $0.textAlignment = .left
        $0.textColor = .gray2
    }
    
    private let secondMajorLabel = UILabel().then {
        $0.text = "제2 |"
        $0.font = .PretendardR(size: 12)
        $0.textAlignment = .left
        $0.textColor = .gray2
    }
    
    private let secondMajorInfoLabel = UILabel().then {
        $0.font = .PretendardR(size: 12)
        $0.textAlignment = .left
        $0.textColor = .gray2
    }
    
    // MARK: Life Cycle
    override func setViews() {
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }
    
    override func prepareForReuse() {
        rankLabel.text = nil
        rankLabel.textColor = .mainDark
        [medalImgView, rankLabel].forEach { $0.isHidden = false }
    }
}

// MARK: - UI
extension RankingTVC {
    private func configureUI() {
        self.backgroundColor = .paleGray
        contentView.backgroundColor = .white
        contentView.makeRounded(cornerRadius: 8.adjusted)
        contentView.addSubviews([medalImgView, rankLabel, profileImgView, responseRateLabel, nicknameLabel, majorLabel, majorInfoLabel, secondMajorLabel, secondMajorInfoLabel])
        
        medalImgView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
            $0.width.equalTo(48)
            $0.height.equalTo(64)
        }
        
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
        }
        
        profileImgView.snp.makeConstraints {
            $0.leading.equalTo(medalImgView.snp.trailing).offset(4)
            $0.centerY.equalTo(medalImgView.snp.centerY)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(profileImgView.snp.trailing).offset(12)
        }
        
        responseRateLabel.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel.snp.centerY)
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
        }
        
        majorLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.leading)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
        }
        
        majorInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(majorLabel.snp.trailing).offset(6)
            $0.centerY.equalTo(majorLabel.snp.centerY)
        }
        
        secondMajorLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.leading)
            $0.top.equalTo(majorLabel.snp.bottom)
        }
        
        secondMajorInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(secondMajorLabel.snp.trailing).offset(6)
            $0.centerY.equalTo(secondMajorLabel.snp.centerY)
        }
    }
}

// MARK: - Custom Methods
extension RankingTVC {
    func setData(data: RankingListModel, indexPath: Int) {
        responseRateLabel.text = "응답률 \(data.rate ?? 0)%"
        nicknameLabel.text = data.nickname
        majorInfoLabel.text = data.firstMajorName + " " + data.firstMajorStart
        secondMajorInfoLabel.text = data.secondMajorName + " " + data.secondMajorStart
        profileImgView.image = UIImage(named: "grayProfileImage\(data.profileImageID)")
        
        switch indexPath {
        case 0...2:
            medalImgView.image = UIImage(named: "icMedal\(indexPath + 1)")
        default:
            medalImgView.isHidden = true
            rankLabel.text = "\(indexPath + 1)"
            
            if indexPath > 4 {
                rankLabel.textColor = .gray3
            }
        }
    }
}
