//
//  HomeSubTitleHeaderCell.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

class HomeSubTitleHeaderCell: BaseTVC {
    
    // MARK: Components
    private let titleLabel = UILabel().then {
        $0.font = .PretendardSB(size: 14)
        $0.textColor = .mainBlack
    }
    let moreBtn = UIButton(type: .system).then {
        $0.configuration = .plain()
        $0.configuration?.image = UIImage(named: "homeMoreIcon")
        $0.configuration?.imagePadding = 9
        $0.setAttributedTitle(NSAttributedString(string: "더보기", attributes: [
            .font: UIFont.PretendardSB(size: 13),
            .foregroundColor: UIColor.gray3
        ]), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleLabel(title: String) {
        titleLabel.text = title
    }
}

// MARK: - UI
extension HomeSubTitleHeaderCell {
    private func configureUI() {
        contentView.addSubviews([titleLabel, moreBtn])
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        moreBtn.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().inset(24)
        }
    }
}
