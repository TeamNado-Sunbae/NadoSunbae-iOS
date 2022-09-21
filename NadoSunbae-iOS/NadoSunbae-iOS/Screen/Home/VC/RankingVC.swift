//
//  RankingVC.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/19.
//

import UIKit
import SnapKit
import Then

class RankingVC: BaseVC {
    
    // MARK: Properties
    private let naviView = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backWithCenterTitle)
        $0.configureTitleLabel(title: "선배랭킹")
        $0.rightCustomBtn.isHidden = true
    }
    
    private let infoView = NadoStatusBarView(contentText: "선배 랭킹은 어떻게 결정되나요?", type: .labelQuestionMarkButton)
    
    private let rankingTV = UITableView()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI
extension RankingVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([naviView, infoView, rankingTV])
        rankingTV.backgroundColor = .paleGray
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        rankingTV.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
