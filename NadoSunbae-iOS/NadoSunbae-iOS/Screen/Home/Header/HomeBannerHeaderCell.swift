//
//  HomeBannerHeaderCell.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/05.
//

import UIKit

final class HomeBannerHeaderCell: BaseTVC {
    
    // MARK: Components
    private let logoImgView = UIImageView().then {
        $0.image = UIImage(named: "logoLogin")
        $0.contentMode = .scaleAspectFill
    }
    private let univLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = .PretendardM(size: 14)
        $0.textColor = .gray4
        $0.text = UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID).getUnivName()
    }
    
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
extension HomeBannerHeaderCell {
    private func configureUI() {
        tintColor = .white
        backgroundColor = .white
        
        addSubviews([logoImgView, univLabel])
        
        logoImgView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(82.adjusted)
            $0.height.equalTo(28.adjusted)
        }
        
        univLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
