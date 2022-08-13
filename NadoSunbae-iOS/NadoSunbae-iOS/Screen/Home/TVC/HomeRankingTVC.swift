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
        contentView.addSubviews([backgroundImgView])
        
        backgroundImgView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
