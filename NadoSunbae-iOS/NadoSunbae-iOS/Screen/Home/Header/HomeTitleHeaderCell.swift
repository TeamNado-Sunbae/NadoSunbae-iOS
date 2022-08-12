//
//  HomeTitleHeaderCell.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/05.
//

import UIKit

class HomeTitleHeaderCell: BaseTVC {
    
    // MARK: Components
    private let titleLabel = UILabel().then {
        $0.font = .PretendardB(size: 18)
        $0.textColor = .mainBlack
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleLabel(titleText: String) {
        titleLabel.text = titleText
        titleLabel.sizeToFit()
    }
}

// MARK: - UI
extension HomeTitleHeaderCell {
    private func configureUI() {
        tintColor = .white
        backgroundColor = .white
        
        addSubviews([titleLabel])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.left.equalToSuperview().inset(24)
        }
    }
}
