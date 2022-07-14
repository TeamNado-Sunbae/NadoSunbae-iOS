//
//  CommunityMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/07/11.
//

import UIKit
import SnapKit
import Then

class CommunityMainVC: BaseVC {
    
    // MARK: Components
    private var tabLabel = UILabel().then {
        $0.text = "커뮤니티"
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI
extension CommunityMainVC {
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews([tabLabel])
        
        tabLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
