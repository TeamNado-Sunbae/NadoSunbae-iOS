//
//  HomeRankingTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

final class HomeRankingTVC: BaseTVC {
    
    // MARK: Components
    private let backgroundImgView = UIImageView().then {
        $0.image = UIImage(named: "homeRankingBG")
    }
    private let firstRankerView = HomeRankerView(type: .first)
    private let secondRankerView = HomeRankerView(type: .secondThird)
    private let thirdRankerView = HomeRankerView(type: .secondThird)
    private let fourthRankerView = HomeRankerView(type: .fourthFifth)
    private let fifthRankerView = HomeRankerView(type: .fourthFifth)
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HomeRankingTVC {
    private func configureUI() {
        contentView.addSubviews([backgroundImgView, firstRankerView, secondRankerView, thirdRankerView, fourthRankerView, fifthRankerView])
        
        backgroundImgView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
        firstRankerView.snp.makeConstraints {
            $0.top.equalTo(backgroundImgView.snp.top).inset(24.adjusted)
            $0.centerX.equalTo(backgroundImgView)
            $0.width.equalTo(screenWidth * 0.192)
            $0.height.equalTo(240.adjusted * 0.491666)
        }
        
        secondRankerView.snp.makeConstraints {
            $0.top.equalTo(backgroundImgView.snp.top).inset(56.adjusted)
            $0.centerX.equalTo(backgroundImgView.snp.centerX).offset(-80.adjusted)
            $0.width.equalTo(screenWidth * 0.184)
            $0.height.equalTo(240.adjusted * 0.441666)
        }
        
        thirdRankerView.snp.makeConstraints {
            $0.top.equalTo(backgroundImgView.snp.top).inset(56.adjusted)
            $0.centerX.equalTo(backgroundImgView.snp.centerX).offset(80.adjusted)
            $0.width.equalTo(screenWidth * 0.184)
            $0.height.equalTo(240.adjusted * 0.441666)
        }
        
        fourthRankerView.snp.makeConstraints {
            $0.top.equalTo(backgroundImgView.snp.top).inset(104.adjusted)
            $0.centerX.equalTo(backgroundImgView.snp.centerX).offset(-151.adjusted)
            $0.width.equalTo(screenWidth * 0.146666)
            $0.height.equalTo(240.adjusted * 0.3)
        }
        
        fifthRankerView.snp.makeConstraints {
            $0.top.equalTo(backgroundImgView.snp.top).inset(104.adjusted)
            $0.centerX.equalTo(backgroundImgView.snp.centerX).offset(151.adjusted)
            $0.width.equalTo(screenWidth * 0.146666)
            $0.height.equalTo(240.adjusted * 0.3)
        }
    }
}
