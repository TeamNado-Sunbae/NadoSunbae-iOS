//
//  HomeBannerCVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/06.
//

import UIKit
import SnapKit
import Then

final class HomeBannerCVC: BaseCVC {
    
    // MARK: Components
    private let imgView = UIImageView()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(imageURL: String) {
        imgView.setImageUrl(imageURL)
    }
}

// MARK: - UI
extension HomeBannerCVC {
    private func configureUI() {
        contentView.addSubviews([imgView])
        
        imgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
