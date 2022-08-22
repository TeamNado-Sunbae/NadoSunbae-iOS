//
//  HomeRecentPersonalQuestionVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/15.
//

import UIKit

final class HomeRecentPersonalQuestionVC: BaseVC {
    
    // MARK: Components
    private let naviView = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backWithCenterTitle)
        $0.configureTitleLabel(title: "최근 1:1 질문")
        $0.rightCustomBtn.isHidden = true
    }
    private let statusBarView = NadoStatusBarView(contentText: "특정 학과 선배에게 1:1 질문을 하고 싶다면 과방탭을 이용하세요.", type: .label)
    
    // MARK: Properties
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - UI
extension HomeRecentPersonalQuestionVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([naviView, statusBarView])
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        statusBarView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
