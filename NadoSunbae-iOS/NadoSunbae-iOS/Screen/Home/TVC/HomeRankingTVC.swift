//
//  HomeRankingTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

final class HomeRankingTVC: BaseTVC {
    
    // MARK: Components
    
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
    }
}
