//
//  HomeFooterCell.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/05.
//

import UIKit

class HomeFooterCell: UITableViewCell {
    
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
extension HomeFooterCell {
    private func configureUI() {
        tintColor = .clear
        backgroundColor = .gray0
    }
}
