//
//  HomeVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/07/11.
//

import UIKit
import SnapKit
import Then

class HomeVC: BaseVC {
    
    // MARK: Components
    private var tabLabel = UILabel().then {
        $0.text = "홈"
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI
extension HomeVC {
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews([tabLabel])
        
        tabLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
