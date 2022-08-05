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
    private var backgroundTV = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .white
    }
    
    // MARK: - Properties
    enum HomeBackgroundTVSectionType: Int {
        case banner = 0, review, questionPerson, community
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setBackgroundTV()
    }
    
    private func setBackgroundTV() {
        backgroundTV.dataSource = self
        backgroundTV.delegate = self
        
        backgroundTV.sectionHeaderTopPadding = 0
        
        backgroundTV.register(HomeBannerHeaderCell.self, forCellReuseIdentifier: HomeBannerHeaderCell.className)
        backgroundTV.register(HomeTitleHeaderCell.self, forCellReuseIdentifier: HomeTitleHeaderCell.className)
        backgroundTV.register(HomeFooterCell.self, forCellReuseIdentifier: HomeFooterCell.className)
    }
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
