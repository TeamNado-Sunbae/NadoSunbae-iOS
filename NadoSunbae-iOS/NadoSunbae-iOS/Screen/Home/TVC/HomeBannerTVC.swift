//
//  HomeBannerTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/06.
//

import UIKit
import SnapKit
import Then

class HomeBannerTVC: BaseTVC {
    
    // MARK: Components
    private let bannerCV = UICollectionView()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HomeTitleHeaderCell {
    private func configureUI() {
        
    }
}
